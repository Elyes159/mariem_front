import 'package:flutter/material.dart';

class Reserv extends StatelessWidget {
  const Reserv({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          elevation: 20.0,
          titleTextStyle:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          shadowColor: Colors.green,
          backgroundColor: Colors.blue,
          centerTitle: true,
        title: const Text("Modification"),),
      body:Container(
                height: 60,
                width: 400,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(500),),
                margin:const  EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 20),
      ),
    );
  }
}
