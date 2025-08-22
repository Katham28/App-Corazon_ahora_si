import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
import '../utils/recursos_Campos.dart';

class Editar_usuario_Widget extends StatefulWidget {
  final Function(Usuario) onGuardar;
  final Usuario usuario;

  const Editar_usuario_Widget({
    super.key,
    required this.onGuardar,
    required this.usuario,
  });

  @override
  State<Editar_usuario_Widget> createState() => Editar_usuario_Widget_State();
}

class Editar_usuario_Widget_State extends State<Editar_usuario_Widget> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _appPatCtrl = TextEditingController();
  final _appMatCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordCtrl2 = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  DateTime? _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    establecerDatos();
  }

  @override
  void didUpdateWidget(covariant Editar_usuario_Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.usuario != widget.usuario) {
      establecerDatos();
    }
  }

  void establecerDatos() {
    print("Estableciendo datos del usuario: ${widget.usuario}");
    _nombreCtrl.text = widget.usuario.name ?? '';
    _appPatCtrl.text = widget.usuario.app_pat ?? '';
    _appMatCtrl.text = widget.usuario.app_mat ?? '';
    _emailCtrl.text = widget.usuario.email ?? '';
    _telefonoCtrl.text =
        widget.usuario.telefono != null ? widget.usuario.telefono.toString() : '';
    _fechaNacimiento = widget.usuario.fecha_nacimiento;

    // Si quieres precargar la contraseña (opcional por seguridad)
    _passwordCtrl.text = widget.usuario.password ?? '';
    _passwordCtrl2.text = widget.usuario.password ?? '';

    setState(() {}); // Actualiza vista si cambia fecha
  }

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
      child: InkWell(
        onTap: seleccionarFecha,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Fecha de nacimiento',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            _fechaNacimiento != null
                ? DateFormat('yyyy-MM-dd').format(_fechaNacimiento!)
                : 'Selecciona una fecha',
            style: TextStyle(
              color: _fechaNacimiento != null ? Colors.black87 : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  bool verificar_formulario() {
    bool flag = false;
    if (_formKey.currentState!.validate() &&
        _fechaNacimiento != null &&
        widget.usuario.type_user.isNotEmpty &&
        _passwordCtrl.text == _passwordCtrl2.text
            && _emailCtrl.text.contains('@') == true ){
      Usuario nuevo = Usuario(
        name: _nombreCtrl.text,
        app_pat: _appPatCtrl.text,
        app_mat: _appMatCtrl.text,
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
        type_user: widget.usuario.type_user,
        fecha_nacimiento: _fechaNacimiento!,
        telefono: int.tryParse(_telefonoCtrl.text) ?? 0,
      );
      widget.onGuardar(nuevo);
      flag = true;
    } else if (_passwordCtrl.text != _passwordCtrl2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      
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
    return Container(
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                titulo('Datos personales', Icon(Icons.badge, color: Colors.blueAccent)),
                campoTexto('Nombre', _nombreCtrl, Icon(Icons.person)),
                campoTexto('Apellido paterno', _appPatCtrl, Icon(Icons.person)),
                campoMaterno('Apellido materno', _appMatCtrl, Icon(Icons.person)),
                campotelefonico('Teléfono', _telefonoCtrl, Icon(Icons.phone),
                    keyboardType: TextInputType.phone),
                campoFechaNacimiento(),
                titulo('Datos de la cuenta',
                    Icon(Icons.account_circle, color: Colors.blueAccent)),
                campocorreo('Correo electrónico', _emailCtrl,
                    Icon(Icons.alternate_email),
                    keyboardType: TextInputType.emailAddress),
                campoTexto('Contraseña', _passwordCtrl, Icon(Icons.password),
                    isPassword: true),
                campoTexto(
                    'Confirmar contraseña', _passwordCtrl2, Icon(Icons.password),
                    isPassword: true),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: verificar_formulario,
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
                      'Actualizar datos',
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

