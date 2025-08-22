import 'package:flutter/material.dart';
import '../widgets/Panel_usuario.dart';
import '../widgets/Panel_medico.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../screens/Pantalla_Menu_Principal.dart';
import '../services/Controlador_Mongo.dart';
import '../widgets/Editar_usuario.dart';

class Pantalla_Inicio_Paciente extends StatefulWidget {
  Usuario user; // ya no es final

  Pantalla_Inicio_Paciente({
    super.key,
    required this.user,
  });

  @override
  State<Pantalla_Inicio_Paciente> createState() => _Pantalla_Inicio_Paciente_State();
}

class _Pantalla_Inicio_Paciente_State extends State<Pantalla_Inicio_Paciente> {
  int _indiceSeleccionado = 0;
  late List<Widget> _pantallas;
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
          actualizar_info(usuarioEditado);
        },
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  void actualizar_info(Usuario newuser) async {
    _mostrarDialogo('Actualizando...');

  if (newuser.email == widget.user.email && newuser.name == widget.user.name &&
      newuser.app_pat == widget.user.app_pat && newuser.app_mat == widget.user.app_mat &&
      newuser.fecha_nacimiento == widget.user.fecha_nacimiento && newuser.telefono == widget.user.telefono
      && newuser.password == widget.user.password) {
      _cerrarDialogo();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Realiza un cambio para actualizar')),
      );
      return;
  }else{
  

      try {
        final controlador = Controlador_Mongo();
        await controlador.connect();
      

        int result = await controlador.findExistingUsuario(newuser.email);
        if (result == 1 && newuser.email != widget.user.email) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ese correo ya está registrado')),
          );
          _cerrarDialogo();
          return;
        } else {
          if (newuser.type_user == 'medico') {
            print('Médico MODIFICADO: ${newuser.toJson()}');
            await controlador.updateUsuario(newuser);
          } else {
            print('Paciente MODIFICADO: ${newuser.toJson()}');

            if(newuser.email !=widget.user.email){
              // Si el correo ha cambiado, actualizamos el usuario en la base de datos
              await controlador.updateUsuario(newuser, oldcorreo: widget.user.email);}
            else{
                await controlador.updateUsuario(newuser);
              }
            
          }

          await controlador.disconnect();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos guardados correctamente')),
          );


          widget.user= newuser;
          _cerrarDialogo();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' Datos actualizados correctamente')),
        );

      
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${e.toString()}')),
        );
        print('Error: $e');
      }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paciente',
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
            icon: Icon(Icons.add),
            label: "Nuevo registro",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial de registros",
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
