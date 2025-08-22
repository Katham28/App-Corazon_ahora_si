import 'package:app_corazon/screens/Pantalla_inicio_medico.dart';
import 'package:app_corazon/screens/Pantalla_inicio_paciente.dart';
import 'package:flutter/material.dart';
import '../widgets/Panel_usuario.dart';
import '../widgets/Panel_medico.dart';
import '../widgets/FormularioInicioSesionWidget.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../screens/Pantalla_Menu_Principal.dart';
import '../screens/Pantalla_Recuperar_Cuenta.dart';

import '../services/Controlador_Mongo.dart';

class Pantalla_Iniciar_sesion extends StatefulWidget {
  const Pantalla_Iniciar_sesion({super.key});

  @override
  State<Pantalla_Iniciar_sesion> createState() => _Pantalla_Iniciar_sesionState();
}

class _Pantalla_Iniciar_sesionState extends State<Pantalla_Iniciar_sesion> {
  String _tipoUsuario = 'paciente';
  Usuario _usuarioBase= Usuario(
    name: '',
    app_pat: '',
    app_mat: '',
    email: '',
    password: '',
    type_user: 'paciente',
    fecha_nacimiento: DateTime.now(),
    telefono: 0,
  );

  final GlobalKey<FormularioInicioSesionWidgetState> _formKeyUsuario = GlobalKey();
  
  // Control para diálogo abierto
  bool _dialogoAbierto = false;


  void buscarUsuario() async{

    final usuarioValido = _formKeyUsuario.currentState?.verificar_formulario() ?? false;
  


  if (!usuarioValido  ) {

    _cerrarDialogo();

    return;
  }


        try {
          _mostrarDialogo('Iniciando sesión...');
            final controlador = Controlador_Mongo();
            await controlador.connect();
            print ("usuarioBase email ${_usuarioBase.email} en usuarioBBase type ${_usuarioBase.type_user}" ); 
            
            int result = await controlador.findExistingUsuario2(_usuarioBase.email,_usuarioBase.type_user);
            if (result == 0) {  // No existe ese correo
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ese correo no esta registrado')),
                );
              await controlador.disconnect();
              _cerrarDialogo();
              return;

            }else{ // Existe ese correo

              Usuario result1 = await controlador.findUsuario(_usuarioBase);
              await controlador.disconnect();
              _cerrarDialogo();



              if ((_usuarioBase.password!=result1.password) && result1.password!='') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Esa contraseña no es correcta')),
                );
                return;

              }else{

                  if (result1.type_user == 'paciente') {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pantalla_Inicio_Paciente(user: result1)),
                          ); 
                  } else if (result1.type_user == 'medico') {
                    print("Navegando a Pantalla_Inicio_Medico: ${result1}");

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pantalla_Inicio_Medico(user: result1  )),
                          ); 
                  } else {
                    throw ArgumentError('Tipo de usuario no válido: ${result1.type_user}');
                  }
              }
          }



          

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
          );
          print('Error: $e');
        }
}



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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión',
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

                // Selector de tipo de usuario
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
                          _usuarioBase.type_user = _tipoUsuario;
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
                            _usuarioBase.type_user = _tipoUsuario;
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

                //Formulario de inicio de sesión
                FormularioInicioSesionWidget(
                  key: _formKeyUsuario,
                  tipoUsuario: _tipoUsuario,
                  onBuscar: (email, password) {
                     _usuarioBase.email = email;
                     _usuarioBase.password = password;

                  },
                ), 
                
                const SizedBox(height: 30),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pantalla_Recuperar_cuenta()),
                          );
                    // Acción para "¿Olvidaste tu contraseña?"
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),


                
                const SizedBox(height: 30),
  
                //VBoton de inicio de sesión
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: buscarUsuario,
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
                      'Iniciar sesión',
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