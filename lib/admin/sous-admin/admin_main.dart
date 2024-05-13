import 'package:flutter/material.dart';
import 'package:projet_pfe/admin/ajout_etranger.dart';
import 'package:projet_pfe/admin/create_abscence.dart';
import 'package:projet_pfe/admin/create_stagiaire.dart';
import 'package:projet_pfe/admin/creer_admin.dart';
import 'package:projet_pfe/admin/creer_emploi.dart';
import 'package:projet_pfe/admin/gerer_eval.dart';
import 'package:projet_pfe/admin/gerer_groups.dart';
import 'package:projet_pfe/admin/gerer_matiere.dart';
import 'package:projet_pfe/admin/get_etranger.dart';
import 'package:projet_pfe/admin/get_reserv.dart';
import 'package:projet_pfe/admin/get_stagiaire.dart';
import 'package:projet_pfe/admin/getdemande.dart';
import 'package:projet_pfe/login.dart';
import 'package:projet_pfe/reservation_home.dart';
import 'package:projet_pfe/inscription1.dart';

class SousAdminMain extends StatelessWidget {
  const SousAdminMain({Key? key});

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
        child: SingleChildScrollView(
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => StagiairePage()),
                  );
                },
                child: const Text('Ajouter un stagiaire'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const CreateEtrangerPage()),
                  );
                },
                child: const Text('Ajouter un étranger'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GetAllStg()),
                  );
                },
                child: const Text('Voir tous les stagiaires'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const EtrangerPage()),
                  );
                },
                child: const Text('Voir tous les étrangers'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => GetReservationPage()),
                  );
                },
                child: const Text('Voir toutes les réservations'),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => UploadImagePage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Créer un emploi'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => DemandesPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Voir les demandes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => CreateAbsencePage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Créer une absence'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MatierePage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Gérer les matières'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GroupPage(),
                    ),
                  );
                },
                child: const Text('Gérer les évaluations'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
