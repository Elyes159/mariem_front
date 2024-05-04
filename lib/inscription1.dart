import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_pfe/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:projet_pfe/provider/code_provider.dart';
import 'package:projet_pfe/reservation_home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'inscriptionstagiaire.dart';

class Inscription1 extends StatefulWidget {
  const Inscription1({Key? key});

  @override
  _Inscription1State createState() => _Inscription1State();
}

class _Inscription1State extends State<Inscription1> {
  String? type;
  final TextEditingController _controllerCode = TextEditingController();
  String errorMessage = '';

  Future<void> saveIdToSharedPreferences(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
  }

  Future<int?> loginEtranger() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final resp = await http.post(
        Uri.parse("http://192.168.1.17:8000/api/login_etranger/"),
        headers: headers,
        body: jsonEncode({"id": _controllerCode.text}),
      );
      if (resp.statusCode == 200) {
        final controllerCodeProvider =
            Provider.of<ControllerCodeProvider>(context, listen: false);
        controllerCodeProvider.setCode(_controllerCode.text);

        saveIdToSharedPreferences(_controllerCode.text);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Reservationhome(),
        ));
      } else {
        print('Erreur: ${resp.statusCode}');
      }
      return resp.statusCode;
    } catch (e) {
      print('Erreur: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const Text("Je suis",
              style: TextStyle(color: Colors.deepPurple, fontSize: 20)),
          RadioListTile(
            contentPadding: const EdgeInsets.only(top: 30, right: 30, left: 30),
            title: const Text("un stagiaire"),
            value: "stagiaire",
            groupValue: type,
            onChanged: (val) {
              setState(() {
                type = val;
              });
            },
          ),
          RadioListTile(
            contentPadding:
                const EdgeInsets.only(top: 10, left: 30, bottom: 20, right: 30),
            activeColor: Colors.cyan[500],
            title: const Text("un groupe étranger"),
            value: "groupe",
            groupValue: type,
            onChanged: (val) {
              setState(() {
                type = val;
              });
            },
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                if (type == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Attention'),
                        content: const Text('Veuillez sélectionner un type.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (type == "stagiaire") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Inscription2()));
                } else if (type == "groupe") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Entrez le code'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _controllerCode,
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Code',
                                hintText: 'Entrez votre code',
                              ),
                            ),
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _controllerCode.clear();
                              setState(() {
                                errorMessage = '';
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              loginEtranger();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child:
                  const Icon(Icons.navigate_next_outlined, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
