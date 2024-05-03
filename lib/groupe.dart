import 'package:flutter/material.dart';
import 'package:projet_pfe/reservation_home.dart';

class Grouppage extends StatelessWidget {
  const Grouppage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
          elevation: 20.0,
          titleTextStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          shadowColor: Colors.green,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text("Home"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            const Center(
              child: Text(
                "Saisie le code",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 50, left: 10, bottom: 10, right: 10),
              child: TextField(
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
                  icon: const Icon(Icons.key),
                  hintText: "Code groupe",
                  hintStyle: const TextStyle(color: Colors.black12),
                  disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple, width: 2)),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Reservationhome()));
                },
                child: const Icon(Icons.navigate_next_outlined,
                    color: Colors.blue),
              ),
            ),
          ]),
        ));
  }
}
