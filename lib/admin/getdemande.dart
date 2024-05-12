import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DemandesPage extends StatefulWidget {
  const DemandesPage({Key? key}) : super(key: key);

  @override
  _DemandesPageState createState() => _DemandesPageState();
}

class _DemandesPageState extends State<DemandesPage> {
  List<dynamic> _demandes = [];
  bool _isLoading = true;

  Future<void> sendEmailConfirmation(String email) async {
    final url =
        Uri.parse('http://192.168.1.17:8000/api/admin/acceptDemande/$email/');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print('Email de confirmation envoyé avec succès');
      } else {
        print(
            'Échec de l\'envoi de l\'email de confirmation: ${response.statusCode}');
        // Afficher un message d'erreur à l'utilisateur
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'email de confirmation: $e');
      // Afficher un message d'erreur à l'utilisateur
    }
  }

  Future<void> fetchDemandes() async {
    final url = Uri.parse('http://192.168.1.17:8000/api/admin/getdemande/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['demandes'];
      setState(() {
        _demandes = data;
        _isLoading = false;
      });
    } else {
      print('Failed to load demandes: ${response.statusCode}');
      // Afficher un message d'erreur ou un message d'état pour l'utilisateur
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDemandes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _demandes.length,
              itemBuilder: (context, index) {
                final demande = _demandes[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () {
                      // Handle button press (e.g., navigate to a detail screen)
                      sendEmailConfirmation(demande["email"]); // Example
                    },
                  ),
                  title: Text('Nom et Prénom: ${demande["nom_prenom"]}'),
                  subtitle: Column(
                    children: [
                      Text('CIN: ${demande["cin"]}'),
                      Text('email: ${demande["email"]}'),
                    ],
                  ),
                  // Ajoutez d'autres champs de demande à afficher ici
                );
              },
            ),
    );
  }
}
