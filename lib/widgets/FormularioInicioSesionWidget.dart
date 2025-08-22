import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
class FormularioInicioSesionWidget extends StatefulWidget {
  final Function(String,String) onBuscar;
  final String tipoUsuario;

  const FormularioInicioSesionWidget({
    super.key,
    required this.onBuscar,
    required this.tipoUsuario,
  });

  @override
  State<FormularioInicioSesionWidget> createState() => FormularioInicioSesionWidgetState();
}

class FormularioInicioSesionWidgetState extends State<FormularioInicioSesionWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();





  bool verificar_formulario() {
    bool flag = false;
    if (_formKey.currentState!.validate() && widget.tipoUsuario.isNotEmpty && _emailCtrl.text.contains('@') )
    {
      widget.onBuscar(_emailCtrl.text, _passwordCtrl.text);
      flag = true;
    }  else if (_emailCtrl.text.contains('@') == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El correo electrónico no es válido.')),
      );
    }

    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos.')),
      );
    }


    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          titulo('Datos de la cuenta', Icon(Icons.account_circle, color: Colors.blueAccent),),
          campoTexto('Correo electrónico', _emailCtrl, Icon(Icons.alternate_email),keyboardType: TextInputType.emailAddress),
          campoTexto('Contraseña', _passwordCtrl,Icon(Icons.password), isPassword: true),

        ],
      ),
    );
  }
}

Widget campoTexto(String label, TextEditingController controller,Icon icon,
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
        suffixIcon:  icon,
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    ),
  );
}


Widget titulo(String text, Icon icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8), // este sí puede ser const
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



 