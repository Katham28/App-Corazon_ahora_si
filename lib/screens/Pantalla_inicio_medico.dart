import 'package:flutter/material.dart';
import '../widgets/Panel_usuario.dart';
import '../widgets/Panel_medico.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../models/Paciente.dart';
import '../screens/Pantalla_Menu_Principal.dart';
import '../services/Controlador_Mongo.dart';
import '../widgets/Editar_usuario.dart';
import '../widgets/Mis_Pacientes.dart';

class Pantalla_Inicio_Medico extends StatefulWidget {
  Usuario user; // ya no es final

  Pantalla_Inicio_Medico({
    super.key,
    required this.user,
  });

  @override
  State<Pantalla_Inicio_Medico> createState() => _Pantalla_Inicio_Medico_State();
}

class _Pantalla_Inicio_Medico_State extends State<Pantalla_Inicio_Medico> {
  int _indiceSeleccionado = 0;
  late List<Widget> _pantallas;
  List<Paciente> listado_pacientes = [];
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


  void actualizar_listado_pacientes(List<Paciente> nuevosPacientes) {
    setState(() {
        //actualizo mis pacientes
    
    });
  }

  Future<void> obtener_pacientes() async {
    listado_pacientes = [
        Paciente(name: "Juan",app_pat:"Perez",app_mat: "Lopez",email: "ddd@", password: "1234", 
        type_user: "paciente", fecha_nacimiento: DateTime(1990,1,1), telefono: 1234567890),

        
        Paciente(name: "Maria",app_pat:"Gomez",app_mat: "Ramirez",email: "ddd@", password: "1234",
        type_user: "paciente", fecha_nacimiento: DateTime(1985,5,15), telefono: 9876543210),

        Paciente(name: "Carlos",app_pat:"Sanchez",app_mat: "Torres",email: "ddd@", password: "1234",
        type_user: "paciente", fecha_nacimiento: DateTime(1978,3,22), telefono: 4561237890),

      ];
  }

  @override
  void initState() {
    super.initState();

    obtener_pacientes();


    _pantallas = [
      const Center(child: Text('🏠 Inicio', style: TextStyle(fontSize: 25))),
        const Center(child: Text('🏠 Inicio', style: TextStyle(fontSize: 25))),
      MisPacientes_Widget(usuario: widget.user, list: listado_pacientes),
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
            if(newuser.email !=widget.user.email){
              await controlador.updateUsuario(newuser, oldcorreo: widget.user.email);}
            else{
                await controlador.updateUsuario(newuser);
              }

          } else {
            print('Paciente MODIFICADO: ${newuser.toJson()}');
            await controlador.updateUsuario(newuser);
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
        selectedItemColor: Colors.blueAccent,   // 👈 color del seleccionado
        unselectedItemColor: Colors.grey,  
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: "Notificaciones",
          ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Añadir pacientes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Mis pacientes",
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
