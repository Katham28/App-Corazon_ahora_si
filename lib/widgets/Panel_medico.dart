import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../utils/recursos_Campos.dart';
import '../services/Controlador_Mongo.dart';

class FormularioMedicoWidget extends StatefulWidget {
  final Function(Medico) onGuardar;
  final String tipoUsuario;

  const FormularioMedicoWidget({
    super.key,
    required this.onGuardar,
    required this.tipoUsuario,
  });

  @override
  State<FormularioMedicoWidget> createState() => FormularioMedicoWidgetState();
}

class FormularioMedicoWidgetState extends State<FormularioMedicoWidget> {
  final _formKey = GlobalKey<FormState>();
  final numcedCtrl = TextEditingController();
  final _verifiCtrl = TextEditingController();


  Future <bool> verificar_codigo() async{
    final controlador = Controlador_Mongo();
    await controlador.connect();
        
       
    bool band = await controlador.findClave_confirmacion(_verifiCtrl.text);
    
     await controlador.disconnect();
  return band;

  }

  bool verificar_formulario() {
      

    if (_formKey.currentState!.validate() && widget.tipoUsuario.isNotEmpty ) {
      final medico = Medico(
        name: '',
        app_pat: '',
        app_mat: '',
        email: '',
        password: '',
        type_user: widget.tipoUsuario,
        fecha_nacimiento: DateTime.now(),
        telefono: 0,
        cedula: int.tryParse(numcedCtrl.text) ?? 0,
        listadoPacientes: [],
      );
      
      widget.onGuardar(medico);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          titulo('Datos profesionales', const Icon(Icons.badge, color: Colors.blueAccent)),
          camponumerico('Número de cédula', numcedCtrl, const Icon(Icons.numbers), keyboardType: TextInputType.number),
          titulo('Verifica la cuenta médica', const Icon(Icons.badge, color: Colors.blueAccent)),
          camponumerico('Código de activación', _verifiCtrl, const Icon(Icons.numbers), keyboardType: TextInputType.number),
        ],
      ),
    );
  }


}