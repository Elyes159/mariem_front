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
  String selectedMatiereId = '';
  String selectedStagiaireId = '';
  List<String> cins = [];
  List<String> matiereIds = [];
  List<dynamic> matieres = [];

  @override
  void initState() {
    super.initState();
    getAllData();
  }

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

        getMatieres(); // Appel à la fonction pour obtenir les matières après avoir récupéré les données initiales
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getMatieres() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.17:8000/api/admin/getmatiere/'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          matieres = responseData['matieres'];
        });
      } else {
        print('Failed to load matieres');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> createAbsence() async {
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
          'matiere_id': selectedMatiereId,
          'nb_heure': nbHeure,
          'periode_id': periodeId,
          'cin': selectedStagiaireId,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Absence créée avec succès')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création de l\'absence')),
        );
      }
    } catch (e) {
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
              controller: _nbHeureController,
              decoration: InputDecoration(labelText: 'Nombre d\'heures'),
            ),
            TextField(
              controller: _periodeIdController,
              decoration: InputDecoration(labelText: 'ID de la période'),
            ),
            DropdownButton<String>(
              value: selectedStagiaireId,
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: createAbsence,
              child: Text('Créer l\'absence'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matieres.length,
                itemBuilder: (context, index) {
                  final matiere = matieres[index];
                  return ListTile(
                    title: Text('ID: ${matiere['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Module: ${matiere['module']}'),
                        Text('Titre Module: ${matiere['titre_module']}'),
                        Text('Nombre d\'heures: ${matiere['nb_heure']}'),
                        Text('Type: ${matiere['type']}'),
                        Text(
                            'ID de la spécialité: ${matiere['specialite_id']}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
