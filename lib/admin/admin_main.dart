import 'package:flutter/material.dart';
import 'package:projet_pfe/admin/ajout_etranger.dart';
import 'package:projet_pfe/admin/create_abscence.dart';
import 'package:projet_pfe/admin/create_stagiaire.dart';
import 'package:projet_pfe/admin/creer_admin.dart';
import 'package:projet_pfe/admin/creer_emploi.dart';
import 'package:projet_pfe/admin/gerer_eval.dart';
import 'package:projet_pfe/admin/gerer_groups.dart';
import 'package:projet_pfe/admin/gerer_matiere.dart';
import 'package:projet_pfe/admin/gerer_sous_admin.dart';
import 'package:projet_pfe/admin/gerer_spec.dart';
import 'package:projet_pfe/admin/get_etranger.dart';
import 'package:projet_pfe/admin/get_reserv.dart';
import 'package:projet_pfe/admin/get_stagiaire.dart';
import 'package:projet_pfe/admin/getdemande.dart';
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
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreerSousAdminPage(),
                          ),
                        );
                      },
                      child: const Text('creer des autres admin'),
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UploadImagePage(),
                          ),
                        );
                      },
                      child: const Text('creer un emploi'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DemandesPage(),
                          ),
                        );
                      },
                      child: const Text('Voir les demandes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateAbsencePage(),
                          ),
                        );
                      },
                      child: const Text('creer une abscence '),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MatierePage(),
                          ),
                        );
                      },
                      child: const Text('Gérer les matiere'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EvaluationPage(),
                          ),
                        );
                      },
                      child: const Text('gerer les evaluations'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SpecialitePage(),
                          ),
                        );
                      },
                      child: const Text('gerer  les spec'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GroupPage(),
                          ),
                        );
                      },
                      child: const Text('gerer les groupes'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SousAdminPage(),
                          ),
                        );
                      },
                      child: const Text('gerer les admins'),
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
