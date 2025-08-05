import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';

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

  bool verificar_formulario() {
      

    if (_formKey.currentState!.validate() && widget.tipoUsuario.isNotEmpty) {
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
          _titulo('Datos profesionales', const Icon(Icons.badge, color: Colors.blueAccent)),
          _campoTexto('Número de cédula', numcedCtrl, const Icon(Icons.numbers), keyboardType: TextInputType.number),
          _titulo('Verifica la cuenta médica', const Icon(Icons.badge, color: Colors.blueAccent)),
          _campoTexto('Código de activación', _verifiCtrl, const Icon(Icons.numbers), keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller, Icon icon,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: icon,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    );
  }

  Widget _titulo(String text, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}