import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Evaluation extends StatelessWidget {
  const Evaluation({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evaluation"),
      ),
      body: FutureBuilder(
        future: getEvaluations(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Les données sont prêtes, vous pouvez les afficher ici
            final evaluations = snapshot.data['evaluations'];
            return ListView.builder(
              itemCount: evaluations.length,
              itemBuilder: (BuildContext context, int index) {
                final evaluation = evaluations[index];
                return ListTile(
                  title: Text('Matiere ID: ${evaluation['matiere_id']}'),
                  subtitle: Text('Note: ${evaluation['note']}'),
                  trailing: Text('Stagiaire ID: ${evaluation['stagiaire_id']}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<String?> getSharedPreferencesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  Future<Map<String, dynamic>> getEvaluations() async {
    final String? token = await getSharedPreferencesToken();
    final String apiUrl = 'http://192.168.1.17:8000/api/getevalbytoken/$token/';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load evaluations');
    }
  }
}
