import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetReservationPage extends StatefulWidget {
  @override
  _GetReservationPageState createState() => _GetReservationPageState();
}

class _GetReservationPageState extends State<GetReservationPage> {
  List<dynamic> reservationsEtranger = [];
  List<dynamic> reservationsStagiaire = [];

  Future<void> fetchReservations() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17:8000/api/admin/getReserv/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        reservationsEtranger = data['reservations_etranger'];
        reservationsStagiaire = data['reservations_stagiaire'];
        print(reservationsStagiaire);
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservations'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Réservations des étrangers'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reservationsEtranger.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                      "nombre de reservation : ${reservationsEtranger.length}"),
                  ListTile(
                    title:
                        Text('Temps: ${reservationsEtranger[index]['temps']}'),
                    subtitle: Text(
                        'Étranger: ${reservationsEtranger[index]['etranger_id']}'),
                    trailing: Text(
                        'Nombre de personnes: ${reservationsEtranger[index]['nombre_personne']}'),
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: Text('Réservations des stagiaires'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reservationsStagiaire.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                      "nombre de reservation : ${reservationsStagiaire.length}"),
                  ListTile(
                    title:
                        Text('Temps: ${reservationsStagiaire[index]['temps']}'),
                    subtitle: Column(
                      children: [
                        Text(
                            'Stagiaire: ${reservationsStagiaire[index]['stagiaire_id']}'),
                        Text(reservationsStagiaire[index]['petit_dej'] == true
                            ? 'petit_dej: ${reservationsStagiaire[index]['petit_dej']}'
                            : ''),
                        Text(reservationsStagiaire[index]['repas_midi'] == true
                            ? 'repas_midi: ${reservationsStagiaire[index]['repas_midi']}'
                            : '')
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
