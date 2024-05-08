import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreerSousAdminPage extends StatefulWidget {
  @override
  _CreerSousAdminPageState createState() => _CreerSousAdminPageState();
}

class _CreerSousAdminPageState extends State<CreerSousAdminPage> {
  final TextEditingController identifiantController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _creerSousAdmin() async {
    const String url =
        'http://192.168.1.17:8000/api/admin/create-admin/'; // Remplacez `your_domain` par votre domaine Django

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'identifiant': identifiantController.text,
        'password': passwordController.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Succès
      print('Succès: ${response.body}');
    } else {
      // Erreur
      print('Erreur: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un sous-administrateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: identifiantController,
              decoration: InputDecoration(labelText: 'Identifiant'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _creerSousAdmin,
              child: Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
