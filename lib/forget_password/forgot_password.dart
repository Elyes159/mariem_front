import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgorPass extends StatefulWidget {
  @override
  _ForgorPassState createState() => _ForgorPassState();
}

class _ForgorPassState extends State<ForgorPass> {
  final _emailController = TextEditingController();

  Future<String?> getSharedPreferencesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  Future<void> _sendGetRequest() async {
    final email = _emailController.text;
    if (email.isEmpty) {
      return; // Handle empty email
    }

    final body = jsonEncode({'email': email}); // Encode email in JSON format

    final response = await http.post(
      Uri.parse('http://192.168.1.17:8000/api/forgot_password/$email/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('POST request successful: ${response.body}');
    } else {
      // Handle error response
      print('POST request failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.green],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendGetRequest,
                  child: Text('Envoyer la demande'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
