import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_pfe/login.dart';
import 'package:http/http.dart' as http;

class Inscription2 extends StatefulWidget {
  const Inscription2({super.key});

  @override
  _Inscription2State createState() => _Inscription2State();
}

class _Inscription2State extends State<Inscription2> {
  TextEditingController cin = TextEditingController();

  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  String errorMessage = '';

  Future<void> createAccount() async {
    String url = 'http://192.168.1.17:8000/api/create_account/';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> donnees = {
      'cin': cin.text,
      'password': passwordController1.text,
      'confirm_passord': passwordController2.text
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(donnees),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Login()));
        print('Réponse: ${response.body}');
      } else {
        print('Échec de la requête: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.blue),
            padding: const EdgeInsets.all(80),
            child: const Text(
              'Bienvenue à notre centre',
              textAlign: TextAlign.center,
              style: TextStyle(
                backgroundColor: Colors.blue,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 50, left: 10, bottom: 10, right: 10),
            child: TextField(
              controller: cin,
              keyboardType: TextInputType.number,
              enabled: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(40),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                icon: const Icon(Icons.person),
                hintText: "Identifiant",
                hintStyle: const TextStyle(color: Colors.black12),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.all(10),
            child: TextField(
              obscureText: true,
              controller: passwordController1,
              enabled: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(40),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                icon: const Icon(Icons.key),
                hintText: "Mot de passe",
                hintStyle: const TextStyle(color: Colors.black12),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.all(10),
            child: TextField(
              obscureText: true,
              controller: passwordController2,
              enabled: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(40),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                icon: const Icon(Icons.key),
                hintText: "Réecrire mot de passe",
                hintStyle: const TextStyle(color: Colors.black12),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 60,
              width: 150,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(500)),
              margin: const EdgeInsets.only(top: 20),
              child: MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  createAccount();
                },
                child: const Text("Se connecter"),
              ),
            ),
          ),
          if (errorMessage
              .isNotEmpty) // Affiche le message d'erreur si le message n'est pas vide
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
