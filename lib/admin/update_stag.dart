import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateStagiaire extends StatefulWidget {
  final String cin;

  UpdateStagiaire({required this.cin});

  @override
  _UpdateStagiaireState createState() => _UpdateStagiaireState();
}

class _UpdateStagiaireState extends State<UpdateStagiaire> {
  TextEditingController prenomController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController dateNaissanceController = TextEditingController();
  TextEditingController lieuNaissanceController = TextEditingController();
  TextEditingController gouvController = TextEditingController();
  TextEditingController codePostalController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController group = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStagiaireDetails();
  }

  Future<void> fetchStagiaireDetails() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.17:8000/api/admin/getstgbycin/${widget.cin}/'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        prenomController.text = responseData['stagiaire']['prenom'];
        nomController.text = responseData['stagiaire']['nom'];
        telController.text = responseData['stagiaire']['tel'];
        dateNaissanceController.text =
            responseData['stagiaire']['date_naissance'];
        lieuNaissanceController.text =
            responseData['stagiaire']['lieu_naissance'];
        gouvController.text = responseData['stagiaire']['gouv'];
        codePostalController.text = responseData['stagiaire']['code_postal'];
        emailController.text = responseData['stagiaire']['email'];
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch stagiaire details.'),
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

  Future<void> updateStagiaire() async {
    final response = await http.put(
      Uri.parse('http://192.168.1.17:8000/api/admin/create_stagiaire/'),
      body: {
        'cin': widget.cin,
        'prenom': prenomController.text,
        'nom': nomController.text,
        'tel': telController.text,
        'date_naissance': dateNaissanceController.text,
        'lieu_naissance': lieuNaissanceController.text,
        'gouv': gouvController.text,
        'code_postal': codePostalController.text,
        'email': emailController.text,
        "code_group": group.text,
      },
    );

    if (response.statusCode == 200) {
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
          content: Text('Failed to update stagiaire.'),
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
        title: Text('Update Stagiaire'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: group,
              decoration: InputDecoration(labelText: 'group'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateStagiaire,
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
