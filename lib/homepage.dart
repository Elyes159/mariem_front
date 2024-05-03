import 'package:flutter/material.dart';
import 'package:projet_pfe/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_pfe/absence.dart';
import 'package:projet_pfe/emploi.dart';
import 'package:projet_pfe/evaluation.dart';
import 'package:projet_pfe/reservation.dart';

class Homepage extends StatelessWidget {
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    // Naviguer vers la page de connexion
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Login(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
        titleTextStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shadowColor: Colors.green,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Home"),
      ),
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: ListTile(
                      title: Text("Mohamed belhaddj"),
                      subtitle: Text("IEB31"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin:
                const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed("profil");
              },
              child: const Text("Consulter profil"),
            ),
          ),
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin:
                const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Evaluation(),
                ));
              },
              child: const Text("Suivi les évaluations"),
            ),
          ),
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin:
                const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Emploi(),
                ));
              },
              child: const Text("Mon emploi"),
            ),
          ),
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin:
                const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Absence(),
                ));
              },
              child: const Text("Suivi les absences"),
            ),
          ),
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin:
                const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Reservation(),
                ));
              },
              child: const Text("Reservation au restaurant"),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              logout(context);
            },
            child: const Text(
              "Déconnexion",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
