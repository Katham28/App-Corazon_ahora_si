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
import '../widgets/Agregar_Pacientes.dart';


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
  List<Paciente> listado_all_pacientes = [];
  bool _loading = true; // 👈 estado de carga
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


  void agregar_listado_pacientes(Usuario newpaciente) async{
     try 
     {
          final controlador = Controlador_Mongo();
          await controlador.connect();


          final result= await controlador.agregar_en_listado_pacientes(newpaciente,widget.user.email, 'Medico');
          await controlador.disconnect();

          if(result.nModified == 0){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('El paciente ya está en tu lista')),
            );
            return;
          }else{
            setState(() {
              listado_pacientes.add(newpaciente as Paciente);
              listado_all_pacientes.remove(newpaciente);
             });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Paciente agregado a tu lista')),
            );

          }

          
    } catch (e) {
          print('Error al obtener pacientes: $e');
        }


  }

  Future<void> obtener_mis_pacientes() async {
     try 
     {
          final controlador = Controlador_Mongo();
          await controlador.connect();

           List<Paciente> pacientes = await controlador. buscar_listado_pacientes(widget.user.email, 'Medico');
           setState(() {
            listado_pacientes = pacientes;
            print('Pacientes obtenidos: ${listado_pacientes}');
          });

          await controlador.disconnect();

    } catch (e) {
          print('Error al obtener pacientes: $e');
        }
  }

  Future <void> obtener_all_pacientes() async {
    try {
      final controlador = Controlador_Mongo();
      await controlador.connect();

      List<Paciente> pacientes = await controlador.findAllUsuario();


      await controlador.disconnect();


      pacientes.removeWhere((pacientes) => listado_pacientes.any((p) => p.email == pacientes.email));

      setState(() {
        listado_all_pacientes = pacientes;
         print('Pacientes obtenidos: ${listado_all_pacientes}');
      });
    } catch (e) {
      print('Error al obtener pacientes: $e');
    }
  }





  @override
    void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {

      await obtener_mis_pacientes();
      await obtener_all_pacientes();

      setState(() {
        _pantallas = [
          const Center(
              child: Text('🏠 Inicio', style: TextStyle(fontSize: 25))),
          AgregarPacientes_Widget(
              usuario: widget.user, 
              list: listado_all_pacientes,
              onAgregar: (newpaciente) {
                print("Paciente agregado: ${newpaciente.name}");
                agregar_listado_pacientes(newpaciente);
                // Aquí puedes actualizar la lista de pacientes si es necesario
              },),
          MisPacientes_Widget(
              usuario: widget.user, list: listado_pacientes),
          Editar_usuario_Widget(
            usuario: widget.user,
            onGuardar: (usuarioEditado) {
              print("Usuario editado: ${usuarioEditado.name}");
              actualizar_info(usuarioEditado);
            },
          ),
        ];
        _loading = false; // 👈 ya cargó todo
      });
    });
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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
