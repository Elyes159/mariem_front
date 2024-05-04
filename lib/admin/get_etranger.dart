import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EtrangerPage extends StatelessWidget {
  const EtrangerPage({Key? key});

  Future<List<dynamic>> fetchEtrangerData() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.17:8000/api/admin/getAllEtr/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['etranger'];
    } else {
      throw Exception('Failed to load Etranger data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Etrangers'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: fetchEtrangerData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              final etrangers = snapshot.data!;
              return ListView.builder(
                itemCount: etrangers.length,
                itemBuilder: (context, index) {
                  final etranger = etrangers[index];
                  return ListTile(
                    title: Text(etranger['id']),
                    subtitle: Text(etranger['nom']),
                    // Ajoutez d'autres champs selon votre modèle Etranger
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
