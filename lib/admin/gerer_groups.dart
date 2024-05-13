import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final TextEditingController numgrController = TextEditingController();
  String? selectedSpecialiteId;
  late List<String> codeSpecs = [];

  String apiUrl = 'http://192.168.1.17:8000/api/admin';

  Future<void> addGroup() async {
    final response = await http.post(
      Uri.parse('$apiUrl/addGroup/'),
      body: {
        'numgr': numgrController.text,
        'specialite_id': selectedSpecialiteId!,
      },
    );

    if (response.statusCode == 201) {
      print('Groupe ajouté avec succès');
    } else {
      print('Échec de l\'ajout du groupe');
    }
  }

  List<dynamic> groups = [];

  Future<void> getGroups() async {
    final response = await http.get(Uri.parse('$apiUrl/getGroup/'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        groups = responseData['groups'];
      });
    } else {
      print('Échec du chargement des groupes');
    }
  }

  Future<void> getAllCodeSpecs() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.17:8000/api/getidspec/'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        codeSpecs = List<String>.from(responseData['code_specs']);
      });
    } else {
      print('Échec du chargement des code_specs');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllCodeSpecs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des groupes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: numgrController,
              decoration: InputDecoration(labelText: 'Numéro de groupe'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedSpecialiteId,
              onChanged: (value) {
                setState(() {
                  selectedSpecialiteId = value;
                });
              },
              items: codeSpecs.map((codeSpec) {
                return DropdownMenuItem<String>(
                  value: codeSpec,
                  child: Text(codeSpec),
                );
              }).toList(),
              hint: Text('Sélectionner le code de spécialité'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addGroup,
              child: Text('Ajouter un groupe'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await getGroups();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Groupes'),
                    content: Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          return ListTile(
                            title: Text('Numéro: ${group['numgr']}'),
                            subtitle: Text(
                                'ID de la spécialité: ${group['specialite_id']}'),
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
              child: Text('Obtenir les groupes'),
            ),
          ],
        ),
      ),
    );
  }
}
