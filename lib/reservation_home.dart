import 'package:flutter/material.dart';
import 'package:projet_pfe/inscription1.dart';
import 'package:projet_pfe/login.dart';
import 'gerer_reserv.dart';
import 'reservation_e.dart';

class Reservationhome extends StatelessWidget {
  const Reservationhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.restaurant_outlined),
        ),
        elevation: 20.0,
        title: const Text(
          "Reservation",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        shadowColor: Colors.green,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin: const EdgeInsets.only(
              right: 20,
              left: 20,
              top: 50,
              bottom: 20,
            ),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReservationE(),
                  ),
                );
              },
              child: const Text("Reserver au restaurant"),
            ),
          ),
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin: const EdgeInsets.only(
              right: 20,
              left: 20,
              top: 50,
              bottom: 20,
            ),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Reserv(),
                  ),
                );
              },
              child: const Text("Modification"),
            ),
          ),
          Container(
            height: 60,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
            ),
            margin: const EdgeInsets.only(
              right: 20,
              left: 20,
              top: 50,
              bottom: 20,
            ),
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Déconnection"),
            ),
          ),
        ],
      ),
    );
  }
}
