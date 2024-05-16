import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpecialitePage extends StatefulWidget {
  @override
  _SpecialitePageState createState() => _SpecialitePageState();
}

class _SpecialitePageState extends State<SpecialitePage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  String apiUrl = 'http://192.168.1.17:8000/api/admin';

  Future<void> addSpecialite() async {
    final response = await http.post(
      Uri.parse('$apiUrl/addspec/'),
      body: jsonEncode({
        'code_spec': codeController.text,
        'nom_spec_ar': nomController.text,
        'type': typeController.text,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      print('Specialité ajoutée avec succès');
      // Clear the text fields after successful addition
      codeController.clear();
      nomController.clear();
      typeController.clear();
      // Refresh the list of specialités
      await getSpecialites();
    } else {
      print('Échec de l\'ajout de la spécialité');
    }
  }

  List<dynamic> specialites = [];

  Future<void> getSpecialites() async {
    final response = await http.get(Uri.parse('$apiUrl/getspec/'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        specialites = responseData['specialites'];
      });
    } else {
      print('Échec du chargement des spécialités');
    }
  }

  Future<void> deleteSpecialite(String codeSpec) async {
    final response =
        await http.delete(Uri.parse('$apiUrl/deletespec/$codeSpec/'));

    if (response.statusCode == 200) {
      print('Specialité supprimée avec succès');
      await getSpecialites();
    } else {
      print('Échec de la suppression de la spécialité');
    }
  }

  @override
  void initState() {
    super.initState();
    getSpecialites(); // Load specialités on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des spécialités'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: codeController,
              decoration: InputDecoration(labelText: 'Code de la spécialité'),
            ),
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: 'Nom de la spécialité'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addSpecialite,
              child: Text('Ajouter une spécialité'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: specialites.length,
                itemBuilder: (context, index) {
                  final specialite = specialites[index];
                  return ListTile(
                    title: Text('Code: ${specialite['code_spec']}'),
                    subtitle: Text('Nom: ${specialite['nom_spec_ar']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Type: ${specialite['type']}'),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteSpecialite(specialite['code_spec']);
                          },
                        ),
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
