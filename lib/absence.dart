import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Absence extends StatefulWidget {
  @override
  _AbsenceState createState() => _AbsenceState();
}

class _AbsenceState extends State<Absence> {
  List<Map<String, dynamic>> _absences = [];
  Future<String?> getSharedPreferencesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  Future<void> fetchAbsences() async {
    final String? token = await getSharedPreferencesToken();
    final url = Uri.parse('http://192.168.1.17:8000/api/getabscence/$token/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['absences'];
      setState(() {
        _absences = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Failed to fetch absences: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAbsences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
        title: Text('Mes absences'),
      ),
      body: _absences.isEmpty
          ? Center(child: Text("tu n'ad pas des abscence"))
          : ListView.builder(
              itemCount: _absences.length,
              itemBuilder: (context, index) {
                final absence = _absences[index];
                return ListTile(
                  title: Text('Matière: ${absence['matiere']}'),
                  subtitle: Text('Nombre d\'heures: ${absence['nb_heure']}'),
                  trailing: Text('Période: ${absence['periode']}'),
                );
              },
            ),
    );
  }
}
