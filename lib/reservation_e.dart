import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projet_pfe/provider/code_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationE extends StatefulWidget {
  const ReservationE({super.key});

  @override
  createState() => _ReservationEState();
}

class _ReservationEState extends State<ReservationE> {
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;
  TextEditingController NbPersonne = TextEditingController();
  Future<String?> getSharedPreferencesId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    return id;
  }

  Future<void> createReservation(
      String temps, bool petitDej, bool repasMidi, bool diner) async {
    final controllerCodeProvider =
        Provider.of<ControllerCodeProvider>(context, listen: false);

    final url = Uri.parse(
        'http://192.168.1.17:8000/api/createRsvForEtg/${controllerCodeProvider.code}/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        // If using token authentication
      },
      body: jsonEncode({
        'petit_dej': petitDej,
        'repas_midi': repasMidi,
        'diner': diner,
        'nombre_personne': NbPersonne.text
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

  Future<void> deleteLastReservation() async {
    final controllerCodeProvider =
        Provider.of<ControllerCodeProvider>(context, listen: false);
    final url = Uri.parse(
        'http://192.168.1.17:8000/api/deleteRsv/${controllerCodeProvider.code}/');

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('DELETE request successful');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('delted succesfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to delete last reservation: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending DELETE request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const Center(
              child: Text(
                " Reservation au Restaurant",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: const Center(
                child: Text(
                  "à partir de 21h à 05:30h",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              color: Colors.grey[300],
              width: 400,
              height: 65,
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
                  final isWithinRange = (now.hour >= 21 && now.minute >= 0) ||
                      now.hour < 5; // Corrected condition

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
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: const Center(
                child: Text(
                  "à partir de 8:30h à 10h",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              color: Colors.grey[300],
              width: 400,
              height: 65,
              child: SwitchListTile(
                title: const Text(
                  "Présent(e)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("le déjeuner"),
                activeColor: Colors.greenAccent[300],
                activeTrackColor: Colors.greenAccent,
                inactiveThumbColor: Colors.grey[900],
                inactiveTrackColor: Colors.grey,
                value: status2,
                onChanged: (val) {
                  final now = DateTime.now();
                  final isWithinRange = now.hour >= 8 && now.hour <= 10;
                  if (isWithinRange) {
                    setState(() {
                      print(val);
                      status2 = val;
                    });
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: const Center(
                child: Text(
                  "à partir de 12h à 15h",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              color: Colors.grey[300],
              width: 400,
              height: 65,
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
                value: status3,
                onChanged: (val) {
                  final now = DateTime.now();
                  final isWithinRange = now.hour >= 12 && now.hour <= 15;
                  if (isWithinRange) {
                    setState(() {
                      print(val);
                      status3 = val;
                    });
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: const Center(
                child: Text(
                  "Nombre de personnes présents",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 100, bottom: 10, right: 100),
              child: TextField(
                controller: NbPersonne,
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
                  hintText: "de 1 à 1000 personnes",
                  hintStyle: const TextStyle(color: Colors.black12),
                  disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 2)),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
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
                              temps = "repasmidi";
                            } else if (status3) {
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
                                temps, status1, status2, status3);
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
            InkWell(
                onTap: () {
                  deleteLastReservation();
                },
                child: Text("Supprimer vos reservation"))
          ],
        ),
      ),
    );
  }
}
