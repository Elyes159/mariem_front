import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import for making HTTP requests

class Reservation extends StatefulWidget {
  const Reservation({super.key});

  @override
  _Reservation createState() => _Reservation();
}

class _Reservation extends State<Reservation> {
  bool status1 = false; // Breakfast (between 9 PM and 8 AM)
  bool status2 = false; // Dinner (between 12 PM and 3 PM)

  String token = ""; // Placeholder for your token
  Future<String?> getSharedPreferencesToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token;
  }

  Future<void> createReservation(
      String temps, bool petitDej, bool repasMidi) async {
    final token = await getSharedPreferencesToken();
    // Replace with your Django API endpoint URL
    final url =
        Uri.parse('http://192.168.1.17:8000/api/createRsvForStg/$token/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        // If using token authentication
      },
      body: jsonEncode({
        'petit_dej': petitDej,
        'repas_midi': repasMidi,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Reservation created successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reservation créée avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Handle errors (e.g., display error message)
      print('Error creating reservation: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la création de la réservation'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          elevation: 20.0,
          title: const Text(
            "Reservation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          shadowColor: Colors.green,
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    " Reservation au Restaurant",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 50,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  child: const Center(
                      child: Text(
                    "à partir de 21h à 08h30",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  )),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  color: Colors.grey[300],
                  width: 400,
                  height: 80,
                  child: SwitchListTile(
                    title: const Text(
                      "Présent(e)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("le petit déjeuner"),
                    activeColor: Colors.greenAccent[300],
                    activeTrackColor: Colors.greenAccent,
                    inactiveThumbColor: Colors.grey[900],
                    inactiveTrackColor: Colors.grey,
                    value: status1,
                    onChanged: (val) {
                      // Check if current time is within allowed range (between 9 PM and 8 AM)
                      final now = DateTime.now();
                      final isWithinRange =
                          (now.hour >= 21 && now.minute >= 0) ||
                              now.hour < 8; // Corrected condition

                      if (isWithinRange) {
                        setState(() {
                          print(val);
                          status1 = val;
                        });
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                  child: const Center(
                      child: Text(
                    "à partir de 12h à 15h",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  )),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  color: Colors.grey[300],
                  width: 400,
                  height: 80,
                  child: SwitchListTile(
                    title: const Text(
                      "Présent(e)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("le diner"),
                    activeColor: Colors.greenAccent[300],
                    activeTrackColor: Colors.greenAccent,
                    inactiveThumbColor: Colors.grey[900],
                    inactiveTrackColor: Colors.grey,
                    value: status2,
                    onChanged: (val) {
                      final now = DateTime.now();
                      final isWithinRange = now.hour >= 12 && now.hour <= 15;
                      if (isWithinRange) {
                        setState(() {
                          print(val);
                          status2 = val;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Confirmation dialog before sending reservation
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmation'),
                          content: const Text('Confirmer la réservation ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Non'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String
                                    temps; // Define reservation time based on status
                                if (status1) {
                                  temps = "Petit déjeuner";
                                } else if (status2) {
                                  temps = "Diner";
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Sélectionnez une option'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                await createReservation(
                                    temps, status1, status2);
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text('Oui'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            )),
      ),
    );
  }
}
