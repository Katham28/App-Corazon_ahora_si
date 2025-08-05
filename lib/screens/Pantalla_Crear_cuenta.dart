import 'package:flutter/material.dart';
import '../widgets/Panel_usuario.dart';
import '../widgets/Panel_medico.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../screens/Pantalla_Menu_Principal.dart';

import '../services/Controlador_Mongo.dart';

class Pantalla_Crear_cuenta extends StatefulWidget {
  const Pantalla_Crear_cuenta({super.key});

  @override
  State<Pantalla_Crear_cuenta> createState() => _Pantalla_Crear_cuentaState();
}

class _Pantalla_Crear_cuentaState extends State<Pantalla_Crear_cuenta> {
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
  Medico? _datosMedico=null;
  final GlobalKey<FormularioUsuarioWidgetState> _formKeyUsuario = GlobalKey();
  final GlobalKey<FormularioMedicoWidgetState> _formKeyMedico = GlobalKey();
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

void _guardarDesdePantalla() async {

  _mostrarDialogo('Guardando datos...');
  final usuarioValido = _formKeyUsuario.currentState?.verificar_formulario() ?? false;
  final medicoValido = _tipoUsuario != 'medico' || 
                      (_formKeyMedico.currentState?.verificar_formulario() ?? false);




  if (!usuarioValido || !medicoValido) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor complete todos los campos requeridos')),
    );


    _cerrarDialogo();

    return;
  }

  try {
    final controlador = Controlador_Mongo();
    await controlador.connect();
      
      int result = await controlador.findExistingUsuario(_usuarioBase.email);
    if (result == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ese correo ya está registrado')),
        );

        
      _cerrarDialogo();
      return;


    }else{
          if (_tipoUsuario == 'medico' && _usuarioBase != null && _datosMedico != null) {
          final medicoCompleto = Medico(
            name: _usuarioBase!.name,
            app_pat: _usuarioBase!.app_pat,
            app_mat: _usuarioBase!.app_mat,
            email: _usuarioBase!.email,
            password: _usuarioBase!.password,
            type_user: _usuarioBase!.type_user,
            fecha_nacimiento: _usuarioBase!.fecha_nacimiento,
            telefono: _usuarioBase!.telefono,
            cedula: _datosMedico!.cedula,
            listadoPacientes: _datosMedico!.listadoPacientes,
          );
          
          print('Médico creado: ${medicoCompleto.toJson()}');
          await controlador.insertUsuario(medicoCompleto);
        } 
        else if (_usuarioBase != null) {
          print('Paciente creado: ${_usuarioBase!.toJson()}');
          await controlador.insertUsuario(_usuarioBase!);
        }

        await controlador.disconnect();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );


        _cerrarDialogo();
    }
      if (mounted) {
        Navigator.pop(context);
      }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al guardar: ${e.toString()}')),
    );
    print('Error: $e');
  }


}

bool verificar_codigo(){
  bool result = true;



  return result;

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear cuenta',
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
                FormularioUsuarioWidget(
                  key: _formKeyUsuario,
                  tipoUsuario: _tipoUsuario,
                  onGuardar: (usuario) {
                     _usuarioBase = usuario ; // Cast explícito
                  },
                ), 
                const SizedBox(height: 20),
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
                if (_tipoUsuario == 'medico') ...[
                  const SizedBox(height: 20),
                  FormularioMedicoWidget(
                    key: _formKeyMedico,
                    tipoUsuario: _tipoUsuario,
                    onGuardar: (medico) {
                      _datosMedico = medico;
                    },
                  ),
                ],
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: _guardarDesdePantalla,
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
                      'Guardar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}