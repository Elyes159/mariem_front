import 'package:flutter/material.dart';

class Absence extends StatelessWidget {
  const Absence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          elevation: 20.0,
          titleTextStyle:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          shadowColor: Colors.green,
          backgroundColor: Colors.blue,
          centerTitle: true,
        title: const Text("Mes absence"),),
      body:Row(
        children: [
          Container()
                  ]
      ),
    );
   }
  }