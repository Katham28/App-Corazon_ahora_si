import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
class FormularioUsuarioWidget extends StatefulWidget {
  final Function(Usuario) onGuardar;
  final String tipoUsuario;

  const FormularioUsuarioWidget({
    super.key,
    required this.onGuardar,
    required this.tipoUsuario,
  });

  @override
  State<FormularioUsuarioWidget> createState() => FormularioUsuarioWidgetState();
}

class FormularioUsuarioWidgetState extends State<FormularioUsuarioWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _appPatCtrl = TextEditingController();
  final _appMatCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
    final _passwordCtrl2 = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  DateTime? _fechaNacimiento;

  void seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
      });
    }
  }

  Widget campoFechaNacimiento() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Fecha de nacimiento',
        border: const OutlineInputBorder(),
        suffixIcon:  Icon(Icons.calendar_today),

        
      ),
      controller: TextEditingController(
        text: _fechaNacimiento != null 
            ? DateFormat('yyyy-MM-dd').format(_fechaNacimiento!)
            : '',
      ),
      validator: (value) => _fechaNacimiento == null 
          ? 'Por favor selecciona una fecha' 
          : null,
      onTap: seleccionarFecha,
    ),
  );
}



  bool verificar_formulario() {
    bool flag = false;
    if (_formKey.currentState!.validate() && _fechaNacimiento != null && widget.tipoUsuario.isNotEmpty
    && _passwordCtrl.text == _passwordCtrl2.text)
    {
      Usuario nuevo = Usuario(
        name: _nombreCtrl.text,
        app_pat: _appPatCtrl.text,
        app_mat: _appMatCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        type_user: widget.tipoUsuario,
        fecha_nacimiento: _fechaNacimiento!,
        telefono: int.tryParse(_telefonoCtrl.text) ?? 0,
      );
      widget.onGuardar(nuevo);
      flag = true;
    }else if (_passwordCtrl.text != _passwordCtrl2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
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

          titulo('Datos personales', Icon(Icons.badge, color: Colors.blueAccent),),
          campoTexto('Nombre', _nombreCtrl,Icon(Icons.person),),
          campoTexto('Apellido paterno', _appPatCtrl,Icon(Icons.person),),
          campoTexto('Apellido materno', _appMatCtrl,Icon(Icons.person),),
          campoTexto('Teléfono', _telefonoCtrl,Icon(Icons.phone), keyboardType: TextInputType.phone),
          campoFechaNacimiento(), // Aquí usamos el nuevo widget

          titulo('Datos de la cuenta', Icon(Icons.account_circle, color: Colors.blueAccent),),
          campoTexto('Correo electrónico', _emailCtrl, Icon(Icons.alternate_email),keyboardType: TextInputType.emailAddress),
          campoTexto('Contraseña', _passwordCtrl,Icon(Icons.password), isPassword: true),
          campoTexto('Confirmar contraseña', _passwordCtrl2,Icon(Icons.password), isPassword: true),
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



 