import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projet_pfe/admin/login.dart';
import 'package:projet_pfe/forget_password/forgot_password.dart';
import 'package:projet_pfe/homepage.dart';
import 'package:projet_pfe/inscription1.dart';
import 'package:http/http.dart' as http;
import 'package:projet_pfe/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController cin = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();

  Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<int?> login() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    try {
      final resp = await http.post(
        Uri.parse("http://192.168.1.17:8000/api/login/"),
        headers: headers,
        body: jsonEncode({
          "cin": cin.text,
          "password": passwordController1.text,
        }),
      );
      if (resp.statusCode == 200) {
        Provider.of<AuthProvider>(context, listen: false).login();
        print('Données envoyées avec succès');
        print("eeeeeee : ${resp.body}");
        print(Provider.of<AuthProvider>(context, listen: false).isLoggedIn);

        final token = jsonDecode(resp.body)['token'] as String;
        saveTokenToSharedPreferences(token);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Homepage(),
        ));
      } else {
        print('Erreur: ${resp.statusCode}');
      }
      print(resp.statusCode);
      return resp.statusCode;
    } catch (e) {
      print('Erreur: $e');
      return null; // Retourner null en cas d'erreur
    }
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
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                padding: const EdgeInsets.all(100),
                child: const Text(
                  'Bienvenue à notre centre',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    backgroundColor: Colors.blue,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 50, left: 10, bottom: 10, right: 10),
                child: TextField(
                  controller: cin,
                  keyboardType: TextInputType.number,
                  enabled: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    icon: const Icon(Icons.person),
                    hintText: "Identifiant",
                    hintStyle: const TextStyle(color: Colors.black12),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.all(10),
                child: TextField(
                  controller: passwordController1,
                  obscureText: true,
                  enabled: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    icon: const Icon(Icons.key),
                    hintText: "Mot de passe",
                    hintStyle: const TextStyle(color: Colors.black12),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple, width: 2)),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 60,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      login();
                    },
                    child: const Text("Se connecter"),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgorPass(),
                      ));
                    },
                    child: const Text("Mot de passe oublié",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Inscription1(),
                      ));
                    },
                    child: const Text("Créer un compte",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminLoginPage(),
                      ));
                    },
                    child: const Text("login en tant que admin",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cin.dispose();
    passwordController1.dispose();
    super.dispose();
  }
}
