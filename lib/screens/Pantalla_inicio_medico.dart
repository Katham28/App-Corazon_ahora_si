import 'package:flutter/material.dart';
import '../widgets/Panel_usuario.dart';
import '../widgets/Panel_medico.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../screens/Pantalla_Menu_Principal.dart';

import '../services/Controlador_Mongo.dart';

class Pantalla_Inicio_Medico extends StatefulWidget {
  const Pantalla_Inicio_Medico({super.key});

  @override
  State<Pantalla_Inicio_Medico> createState() => _Pantalla_Inicio_Medico_State();
}

class _Pantalla_Inicio_Medico_State extends State<Pantalla_Inicio_Medico> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Médico',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shadowColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        toolbarHeight: 70,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 30),
                
                



                
                

              ],
            ),
          ),
        ),
      ),
    );
  }
}