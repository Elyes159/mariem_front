import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DemandeForm extends StatefulWidget {
  @override
  _DemandeFormState createState() => _DemandeFormState();
}

class _DemandeFormState extends State<DemandeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomPrenomController = TextEditingController();
  final _cinController = TextEditingController();
  final _emailController = TextEditingController();
  final _causeController = TextEditingController();

  @override
  void dispose() {
    _nomPrenomController.dispose();
    _cinController.dispose();
    _emailController.dispose();
    _causeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nomPrenomController,
                decoration: InputDecoration(labelText: 'Nom et Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nom et Prénom requis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cinController,
                decoration: InputDecoration(labelText: 'CIN'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CIN requis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email requis';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _causeController,
                decoration: InputDecoration(labelText: 'Cause'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cause requise';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Submit the form data to the API
                    _submitDemande();
                  }
                },
                child: Text('Soumettre Demande'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitDemande() async {
    final nomPrenom = _nomPrenomController.text;
    final cin = _cinController.text;
    final email = _emailController.text;
    final cause = _causeController.text;

    try {
      // Send the data to the API using a suitable HTTP client (e.g., http package)
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.17:8000/api/demande/'), // Replace with your API URL
        body: {
          'nom_prenom': nomPrenom,
          'cin': cin,
          'email': email,
          'cause': cause,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Demande envoyée avec succès!'),
        ));
      } else {
        // Handle error response
        print('Error sending demande: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de l\'envoi de la demande.'),
        ));
      }
    } catch (error) {
      print('Error sending demande: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'envoi de la demande.'),
      ));
    }
  }
}
