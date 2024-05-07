import 'package:flutter/material.dart';
import 'package:projet_pfe/admin/ajout_etranger.dart';
import 'package:projet_pfe/admin/create_stagiaire.dart';
import 'package:projet_pfe/admin/get_etranger.dart';
import 'package:projet_pfe/admin/get_reserv.dart';
import 'package:projet_pfe/admin/get_stagiaire.dart';
import 'package:projet_pfe/login.dart';
import 'package:projet_pfe/reservation_home.dart';
import 'package:projet_pfe/inscription1.dart';

class AdminCustomPage extends StatelessWidget {
  const AdminCustomPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Page'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => StagiairePage()),
                        );
                      },
                      child: const Text('Ajouter un stagiaire'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const CreateEtrangerPage()),
                        );
                      },
                      child: const Text('Ajouter un etranger'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => GetAllStg()),
                        );
                      },
                      child: const Text('Voir tout les stagiiare'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const EtrangerPage()),
                        );
                      },
                      child: const Text('Voir tout les etranger'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => GetReservationPage()),
                        );
                      },
                      child: const Text('Voir tout les réservation'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Déconnexion'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
