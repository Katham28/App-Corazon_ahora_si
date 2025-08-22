import 'package:flutter/material.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../screens/Pantalla_Menu_Principal.dart';
import '../utils/recursos_Campos.dart';

import '../services/Controlador_Mongo.dart';

class Pantalla_Recuperar_cuenta extends StatefulWidget {
  const Pantalla_Recuperar_cuenta({super.key});

  @override
  State<Pantalla_Recuperar_cuenta> createState() => Pantalla_Recuperar_cuentaState();
}

class Pantalla_Recuperar_cuentaState extends State<Pantalla_Recuperar_cuenta> {
  String _tipoUsuario = 'paciente';


  // Control para diálogo abierto
  bool _dialogoAbierto = false;




  void _mostrarDialogo(String mensaje) {
    if (_dialogoAbierto) return;
    _dialogoAbierto = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(mensaje)),
          ],
        ),
      ),
    ).then((_) {
      _dialogoAbierto = false;
    });
  }

  void _cerrarDialogo() {
    if (_dialogoAbierto && mounted && Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
      _dialogoAbierto = false;
    }
  }

  Future <bool> verificar_codigo() async{
    final controlador = Controlador_Mongo();
    await controlador.connect();
        
       
    bool band = await controlador.findClave_confirmacion("");
    
     await controlador.disconnect();
  return band;

  }

void _cambiar_contrasenia() async {

  

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recuperar Cuenta',
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
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text('Soy un Médico', style: TextStyle(color: Colors.blueAccent)),
                        ],
                      ),
                      selected: _tipoUsuario == 'medico',
                      onSelected: (selected) {
                        setState(() {
                          _tipoUsuario = selected ? 'medico' : 'paciente';
                        });
                      },
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      elevation: 3,
                      pressElevation: 5,
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.elderly, color: Colors.blueAccent),
                          SizedBox(width: 8),
                          Text('Soy un Paciente', style: TextStyle(color: Colors.blueAccent)),
                        ],
                      ),
                      selected: _tipoUsuario == 'paciente',
                      onSelected: (selected) {
                        setState(() {
                          _tipoUsuario = selected ? 'paciente' : 'medico';
                        });
                      },
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      elevation: 3,
                      pressElevation: 5,
                    ),
                  ],
                ),









                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: _cambiar_contrasenia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      shadowColor: Colors.blue[800],
                    ),
                    child: const Text(
                      'Recuperar Cuenta',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),


                const SizedBox(height: 20),


              ],
            ),
          ),
        ),
      ),
    );
  }
}