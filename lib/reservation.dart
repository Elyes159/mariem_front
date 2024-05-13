import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_pfe/admin/create_stagiaire.dart';

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  _ReservationState createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
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

  Future<void> deleteReservation() async {
    final token = await getSharedPreferencesToken();
    final url =
        Uri.parse('http://192.168.1.17:8000/api/deleteReservation/$token/');

    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        // Ajoutez d'autres en-têtes si nécessaire (par exemple, le jeton d'authentification)
      },
    );

    if (response.statusCode == 200) {
      // Réservation supprimée avec succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Réservation supprimée avec succès',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Gérer les erreurs (par exemple, afficher un message d'erreur)
      print(
          'Erreur lors de la suppression de la réservation: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression de la réservation',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Center(
                child: Text(
                  " Reservation au Restaurant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 50,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Center(
                  child: Text(
                    "à partir de 21h à 08h30",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                color: Colors.grey[300],
                width: 400,
                height: 80,
                child: SwitchListTile(
                  title: Text(
                    "Présent(e)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text("le petit déjeuner",
                      style: TextStyle(color: Colors.black)),
                  activeColor: Colors.greenAccent[300],
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.grey[900],
                  inactiveTrackColor: Colors.grey,
                  value: status1,
                  onChanged: (val) {
                    // Check if current time is within allowed range (between 9 PM and 8 AM)
                    final now = DateTime.now();
                    final isWithinRange = (now.hour >= 21 && now.minute >= 0) ||
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
                margin: EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Center(
                  child: Text(
                    "à partir de 12h à 15h",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                color: Colors.grey[300],
                width: 400,
                height: 80,
                child: SwitchListTile(
                  title: Text(
                    "Présent(e)",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle:
                      Text("le diner", style: TextStyle(color: Colors.black)),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmation',
                            style: TextStyle(color: Colors.white)),
                        content: Text('Confirmer la réservation ?',
                            style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.blue,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Non',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () async {
                              String temps;
                              if (status1) {
                                temps = "Petit déjeuner";
                              } else if (status2) {
                                temps = "Diner";
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sélectionnez une option',
                                        style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              await createReservation(temps, status1, status2);
                              Navigator.of(context).pop();
                            },
                            child: Text('Oui',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.check, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  // Appeler la fonction de suppression de la réservation
                  deleteReservation();
                },
                icon: Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
