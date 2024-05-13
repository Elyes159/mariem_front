import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EvaluationPage extends StatefulWidget {
  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final TextEditingController noteController = TextEditingController();
  String selectedMatiereId = ''; // ID de la matière sélectionnée
  String selectedStagiaireId = ''; // ID du stagiaire sélectionné

  String apiUrl = 'http://192.168.1.17:8000/api/admin';

  Future<void> createEvaluation() async {
    final response = await http.post(
      Uri.parse('$apiUrl/createeval/'),
      body: {
        'matiere_id': selectedMatiereId,
        'note': noteController.text,
        'stagiaire_cin': selectedStagiaireId,
      },
    );

    if (response.statusCode == 201) {
      print('Evaluation created successfully');
    } else {
      print('Failed to create evaluation');
    }
  }

  List<String> cins = [];
  List<String> matiereIds = [];

  Future<void> getAllData() async {
    try {
      final responseStagiaireCin =
          await http.get(Uri.parse("http://192.168.1.17:8000/api/getAllcin/"));
      final responseMatiereIds =
          await http.get(Uri.parse('http://192.168.1.17:8000/api/getAllMId/'));

      if (responseStagiaireCin.statusCode == 200 &&
          responseMatiereIds.statusCode == 200) {
        final responseDataStagiaireCin = json.decode(responseStagiaireCin.body);
        final responseDataMatiereIds = json.decode(responseMatiereIds.body);

        setState(() {
          cins = List<String>.from(responseDataStagiaireCin['cins']);
          matiereIds = List<String>.from(responseDataMatiereIds['matiere_ids']);
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<dynamic> evaluations = [];

  Future<void> getEvaluations() async {
    final response = await http.get(Uri.parse('$apiUrl/geteval/'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        evaluations = responseData['evaluations'];
      });
    } else {
      print('Failed to load evaluations');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluation Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedMatiereId,
              onChanged: (value) {
                setState(() {
                  selectedMatiereId = value!;
                });
              },
              items: matiereIds.map((matiereId) {
                return DropdownMenuItem<String>(
                  value: matiereId,
                  child: Text(matiereId),
                );
              }).toList(),
              hint: Text('Select Matiere ID'),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
            DropdownButton<String>(
              value: cins.contains(selectedStagiaireId)
                  ? selectedStagiaireId
                  : null,
              onChanged: (value) {
                setState(() {
                  selectedStagiaireId = value!;
                });
              },
              items: cins.map((cin) {
                return DropdownMenuItem<String>(
                  value: cin,
                  child: Text(cin),
                );
              }).toList(),
              hint: Text('Select Stagiaire ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createEvaluation,
              child: Text('CREATE Evaluation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await getEvaluations();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Evaluations'),
                    content: Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: evaluations.length,
                        itemBuilder: (context, index) {
                          final evaluation = evaluations[index];
                          return ListTile(
                            title:
                                Text('Matier_ID: ${evaluation['matiere_id']}'),
                            subtitle: Text('Note: ${evaluation['note']}'),
                            trailing: Text(
                                'Stagiaire ID: ${evaluation['stagiaire_id']}'),
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('GET Evaluations'),
            ),
          ],
        ),
      ),
    );
  }
}
