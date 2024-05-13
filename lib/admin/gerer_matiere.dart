import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MatierePage extends StatefulWidget {
  @override
  _MatierePageState createState() => _MatierePageState();
}

class _MatierePageState extends State<MatierePage> {
  String apiUrl = 'http://192.168.1.17:8000/api/admin';
  List matieres = [];
  List<String> codeSpecs = [];
  TextEditingController moduleController = TextEditingController();
  TextEditingController titreModuleController = TextEditingController();
  TextEditingController nbHeureController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  String? selectedCodeSpec;

  @override
  void initState() {
    super.initState();
    getCodeSpecs();
  }

  Future<void> getCodeSpecs() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.17:8000/api/getidspec/'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        codeSpecs = List<String>.from(responseData['code_specs']);
      });
    } else {
      print('Failed to load code specs');
    }
  }

  Future<void> createMatiere() async {
    final response =
        await http.post(Uri.parse('$apiUrl/creatematiere/'), body: {
      'module': moduleController.text,
      'titre_module': titreModuleController.text,
      'nb_heure': nbHeureController.text,
      'type': typeController.text,
      'specialite_id': selectedCodeSpec ?? '', // Use selected code spec
    });
    if (response.statusCode == 201) {
      print('Matiere created successfully');
    } else {
      print('Failed to create matiere');
    }
  }

  Future<void> deleteMatiere(String matiereId) async {
    final response =
        await http.delete(Uri.parse('$apiUrl/deletematiere/$matiereId/'));
    if (response.statusCode == 200) {
      print('Matiere deleted successfully');
    } else {
      print('Failed to delete matiere');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matiere Page'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: getCodeSpecs,
            child: Text('GET Code Specs'),
          ),
          DropdownButtonFormField<String>(
            value: selectedCodeSpec,
            onChanged: (value) {
              setState(() {
                selectedCodeSpec = value;
              });
            },
            items: codeSpecs.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Code Spec',
              border: OutlineInputBorder(),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: matieres.length,
            itemBuilder: (context, index) {
              final matiere = matieres[index];
              return ListTile(
                title: Text('Matiere ID: ${matiere['id']}'),
                subtitle: Text('Module: ${matiere['module']}'),
                trailing: ElevatedButton(
                  onPressed: () => deleteMatiere(matiere['id'].toString()),
                  child: Text('DELETE'),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: moduleController,
                  decoration: InputDecoration(labelText: 'Module'),
                ),
                TextField(
                  controller: titreModuleController,
                  decoration: InputDecoration(labelText: 'Titre Module'),
                ),
                TextField(
                  controller: nbHeureController,
                  decoration: InputDecoration(labelText: 'Nombre d\'heure'),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'Type'),
                ),
                ElevatedButton(
                  onPressed: createMatiere,
                  child: Text('CREATE Matiere'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
