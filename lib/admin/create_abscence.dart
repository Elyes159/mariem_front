import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateAbsencePage extends StatefulWidget {
  const CreateAbsencePage({Key? key}) : super(key: key);

  @override
  _CreateAbsencePageState createState() => _CreateAbsencePageState();
}

class _CreateAbsencePageState extends State<CreateAbsencePage> {
  final TextEditingController _matiereIdController = TextEditingController();
  final TextEditingController _nbHeureController = TextEditingController();
  final TextEditingController _periodeIdController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();

  Future<void> _createAbsence() async {
    final String matiereId = _matiereIdController.text;
    final String nbHeure = _nbHeureController.text;
    final String periodeId = _periodeIdController.text;
    final String cin = _cinController.text;

    const String apiUrl = 'http://192.168.1.17:8000/api/admin/createabscence/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'matiere_id': matiereId,
          'nb_heure': nbHeure,
          'periode_id': periodeId,
          'cin': cin,
        }),
      );

      if (response.statusCode == 201) {
        // Absence créée avec succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Absence créée avec succès')),
        );
      } else {
        // Erreur lors de la création de l'absence
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de l\'absence')),
        );
      }
    } catch (e) {
      // Erreur réseau ou autre erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une absence'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _matiereIdController,
              decoration: InputDecoration(labelText: 'ID de la matière'),
            ),
            TextField(
              controller: _nbHeureController,
              decoration: InputDecoration(labelText: 'Nombre d\'heures'),
            ),
            TextField(
              controller: _periodeIdController,
              decoration: InputDecoration(labelText: 'ID de la période'),
            ),
            TextField(
              controller: _cinController,
              decoration: InputDecoration(labelText: 'CIN du stagiaire'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createAbsence,
              child: Text('Créer l\'absence'),
            ),
          ],
        ),
      ),
    );
  }
}
