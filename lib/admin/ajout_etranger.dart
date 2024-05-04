import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateEtrangerPage extends StatefulWidget {
  const CreateEtrangerPage({Key? key}) : super(key: key);

  @override
  _CreateEtrangerPageState createState() => _CreateEtrangerPageState();
}

class _CreateEtrangerPageState extends State<CreateEtrangerPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  String errorMessage = '';

  Future<void> createEtranger() async {
    String url = 'http://192.168.1.17:8000/api/admin/createEtr/';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> data = {
      'id': idController.text,
      'nom': nomController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        // Etranger créé avec succès, afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Etranger créé avec succès'),
            backgroundColor: Colors.green,
          ),
        );

        // Effacer les champs du formulaire
        idController.clear();
        nomController.clear();
      } else {
        // Afficher un message d'erreur
        setState(() {
          errorMessage = 'Erreur: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Etranger'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createEtranger,
              child: Text('Créer'),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
