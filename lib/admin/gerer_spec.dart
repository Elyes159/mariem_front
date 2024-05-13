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
            ElevatedButton(
              onPressed: () async {
                await getSpecialites();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Spécialités'),
                    content: Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: specialites.length,
                        itemBuilder: (context, index) {
                          final specialite = specialites[index];
                          return ListTile(
                            title: Text('Code: ${specialite['code_spec']}'),
                            subtitle: Text('Nom: ${specialite['nom_spec_ar']}'),
                            trailing: Text('Type: ${specialite['type']}'),
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Obtenir les spécialités'),
            ),
          ],
        ),
      ),
    );
  }
}
