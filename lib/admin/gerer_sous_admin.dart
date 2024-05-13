import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SousAdminPage extends StatefulWidget {
  @override
  _SousAdminPageState createState() => _SousAdminPageState();
}

class _SousAdminPageState extends State<SousAdminPage> {
  List<dynamic> sousAdmins = [];

  Future<void> getSousAdmins() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17:8000/api/admin/getsousadmin/'));
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        sousAdmins = responseData['sous_admins'];
      });
    } else {
      print('Échec du chargement des sous-admins');
    }
  }

  Future<void> deleteSousAdmin(String identifiant) async {
    final response = await http.delete(Uri.parse(
        'http://192.168.1.17:8000/api/admin/deletesousadmin/$identifiant/'));
    if (response.statusCode == 200) {
      print('Sous-admin supprimé avec succès');
      getSousAdmins(); // Recharger la liste après la suppression
    } else {
      print('Échec de la suppression du sous-admin');
    }
  }

  @override
  void initState() {
    super.initState();
    getSousAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des sous-administrateurs'),
      ),
      body: ListView.builder(
        itemCount: sousAdmins.length,
        itemBuilder: (context, index) {
          final sousAdmin = sousAdmins[index];
          return ListTile(
            title: Text('Identifiant: ${sousAdmin['identifiant']}'),
            subtitle: Text('Mot de passe: ${sousAdmin['password']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                        'Voulez-vous vraiment supprimer ce sous-administrateur ?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteSousAdmin(sousAdmin['identifiant']);
                          Navigator.pop(context);
                        },
                        child: Text('Supprimer'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
