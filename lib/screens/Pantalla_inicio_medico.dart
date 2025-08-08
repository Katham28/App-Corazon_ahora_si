import 'package:flutter/material.dart';
import '../widgets/Panel_usuario.dart';
import '../widgets/Panel_medico.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../screens/Pantalla_Menu_Principal.dart';
import '../services/Controlador_Mongo.dart';
import '../widgets/Editar_usuario.dart';

class Pantalla_Inicio_Medico extends StatefulWidget {
  final Usuario user; 

  const Pantalla_Inicio_Medico({
    super.key,
    required this.user, 
  });

  @override
  State<Pantalla_Inicio_Medico> createState() => _Pantalla_Inicio_Medico_State();
}

class _Pantalla_Inicio_Medico_State extends State<Pantalla_Inicio_Medico> {
  int _indiceSeleccionado = 0;
  late List<Widget> _pantallas;

  @override
  void initState() {
    super.initState();
    _pantallas = [
      const Center(child: Text('🏠 Inicio', style: TextStyle(fontSize: 25))),
      const Center(child: Text('📄 Perfil', style: TextStyle(fontSize: 25))),
      Editar_usuario_Widget(
        usuario: widget.user,
        onGuardar: (usuarioEditado) {
          print("Usuario editado: ${usuarioEditado.name}");
        },
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

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
      body: _pantallas[_indiceSeleccionado],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSeleccionado,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: "Notificaciones",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.elderly),
            label: "Listado pacientes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Cuenta",
          ),
        ],
      ),
    );
  }
}
