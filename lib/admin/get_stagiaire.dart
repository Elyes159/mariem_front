import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetAllStg extends StatefulWidget {
  @override
  _GetAllStgState createState() => _GetAllStgState();
}

class _GetAllStgState extends State<GetAllStg> {
  List<Map<String, dynamic>> stagiaires = [];

  Future<void> fetchStagiaires() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.17:8000/api/admin/getAllStg'),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        stagiaires =
            List<Map<String, dynamic>>.from(responseData['stagiaires']);
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch stagiaires.'),
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

  Future<void> deleteStagiaire(String cin) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.17:8000/api/admin/deleteStg/$cin/'),
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
                fetchStagiaires(); // Rafraîchir la liste des stagiaires après suppression
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
          content: Text('Failed to delete stagiaire.'),
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
  void initState() {
    super.initState();
    fetchStagiaires();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stagiaires'),
      ),
      body: ListView.builder(
        itemCount: stagiaires.length,
        itemBuilder: (context, index) {
          final stagiaire = stagiaires[index];
          return ListTile(
            title: Text(stagiaire['prenom'] + ' ' + stagiaire['nom']),
            subtitle: Text(stagiaire['email']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteStagiaire(stagiaire['cin']),
            ),
          );
        },
      ),
    );
  }
}
