import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_pfe/admin/admin_main.dart';
import 'package:projet_pfe/admin/create_stagiaire.dart';
import 'package:http/http.dart' as http;
import 'package:projet_pfe/admin/sous-admin/admin_main.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() {
    // Ajoutez votre logique de connexion ici
    String email = emailController.text;
    String password = passwordController.text;
  }

  Future<int> _loginSousAdmin() async {
    const String url = 'http://192.168.1.17:8000/api/LoginSAdmin/';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'identifiant': emailController.text,
        'password': passwordController.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Succès
      print('Succès: ${response.body}');
    } else {
      // Erreur
      print('Erreur: ${response.reasonPhrase}');
    }

    return response.statusCode; // Retourne le code d'état de la réponse HTTP
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    int statusCode = await _loginSousAdmin();
                    if ((emailController.text == "admin") &&
                        (passwordController.text == "admin")) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminCustomPage(),
                      ));
                    } else if (statusCode == 200) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SousAdminMain(),
                      ));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Erreur'),
                            content: Text('quelque chose incorrecte.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
