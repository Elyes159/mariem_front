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
  int totalReservationsEtranger = 0;
  int totalReservationsStagiaire = 0;

  Future<void> fetchReservations() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.17:8000/api/admin/getReserv/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        reservationsEtranger = data['reservations_etranger'];
        reservationsStagiaire = data['reservations_stagiaire'];
        totalReservationsEtranger = data['nombre_total_reservations_etranger'];
        totalReservationsStagiaire =
            data['nombre_total_reservations_stagiaire'];
      });
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  Future<void> deleteReservationEtranger(int id) async {
    final response = await http.delete(Uri.parse(
        'http://192.168.1.17:8000/api/admin/deleteReservationEtranger/$id/'));

    if (response.statusCode == 200) {
      fetchReservations(); // Re-fetch reservations after deletion
    } else {
      throw Exception('Failed to delete reservation');
    }
  }

  Future<void> deleteReservationStagiaire(int id) async {
    final response = await http.delete(Uri.parse(
        'http://192.168.1.17:8000/api/admin/deleteReservationStagiaire/$id/'));

    if (response.statusCode == 200) {
      fetchReservations(); // Re-fetch reservations after deletion
    } else {
      throw Exception('Failed to delete reservation');
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
            title:
                Text('Réservations des étrangers ($totalReservationsEtranger)'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reservationsEtranger.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title:
                        Text('Temps: ${reservationsEtranger[index]['temps']}'),
                    subtitle: Column(
                      children: [
                        Text(
                            'Étranger: ${reservationsEtranger[index]['nombre_personne']}'),
                        Text(
                            'Étranger: ${reservationsEtranger[index]['etranger']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteReservationEtranger(
                            reservationsEtranger[index]['id']);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: Text(
                'Réservations des stagiaires ($totalReservationsStagiaire)'),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reservationsStagiaire.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title:
                        Text('Temps: ${reservationsStagiaire[index]['temps']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Stagiaire: ${reservationsStagiaire[index]['stagiaire_id']}'),
                        Text(reservationsStagiaire[index]['petit_dej'] == true
                            ? 'petit_dej: Oui'
                            : ''),
                        Text(reservationsStagiaire[index]['repas_midi'] == true
                            ? 'repas_midi: Oui'
                            : ''),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteReservationStagiaire(
                            reservationsStagiaire[index]['id']);
                      },
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
