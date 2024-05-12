import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projet_pfe/admin/get_stagiaire.dart';

class StagiairePage extends StatefulWidget {
  @override
  _StagiairePageState createState() => _StagiairePageState();
}

class _StagiairePageState extends State<StagiairePage> {
  final TextEditingController cinController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController lieuNaissanceController = TextEditingController();
  final TextEditingController gouvController = TextEditingController();
  final TextEditingController codePostalController = TextEditingController();
  final TextEditingController codeQRController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> createOrUpdateStagiaire() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.17:8000/api/admin/create_stagiaire/'),
      body: {
        'cin': cinController.text,
        'prenom': prenomController.text,
        'nom': nomController.text,
        'tel': telController.text,
        'date_naissance': dateNaissanceController.text,
        'lieu_naissance': lieuNaissanceController.text,
        'gouv': gouvController.text,
        'code_postal': codePostalController.text,
        'code_group': codeQRController.text,
        'email': emailController.text,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success'),
          content: Text(responseData['message']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to create or update stagiaire.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create or Update Stagiaire'),
        backgroundColor:
            Colors.blue, // Personnaliser la couleur de la barre d'application
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Stagiaire Page', // Changer le titre
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: cinController,
                  decoration: InputDecoration(labelText: 'CIN'),
                ),
                TextField(
                  controller: prenomController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                ),
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: telController,
                  decoration: InputDecoration(labelText: 'Téléphone'),
                ),
                TextField(
                  controller: dateNaissanceController,
                  decoration: InputDecoration(labelText: 'Date de naissance'),
                ),
                TextField(
                  controller: lieuNaissanceController,
                  decoration: InputDecoration(labelText: 'Lieu de naissance'),
                ),
                TextField(
                  controller: gouvController,
                  decoration: InputDecoration(labelText: 'Gouvernorat'),
                ),
                TextField(
                  controller: codePostalController,
                  decoration: InputDecoration(labelText: 'Code postal'),
                ),
                TextField(
                  controller: codeQRController,
                  decoration: InputDecoration(labelText: 'Code groupe'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: createOrUpdateStagiaire,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Personnaliser la couleur du bouton
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetAllStg(),
                    ));
                  },
                  child: Text('Voir tout les stagiaires'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
