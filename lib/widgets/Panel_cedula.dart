import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:intl/intl.dart';

class Panel_Cedula extends StatelessWidget {
  const Panel_Cedula({super.key});
 
  @override
  Widget build(BuildContext context) {
  int? _selectedYear;
  final TextEditingController _yearController = TextEditingController();
      
Future<void> _selectYear(BuildContext context) async {
  final DateTime? picked = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Seleccione el año"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearPicker(
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            initialDate: DateTime(_selectedYear ?? DateTime.now().year - 18),
            selectedDate: DateTime(_selectedYear ?? DateTime.now().year - 18),
            onChanged: (DateTime dateTime) {
              Navigator.pop(context, dateTime);
            },
          ),
        ),
      );
    },
  );

  if (picked != null) {
    _selectedYear = picked.year;
    _yearController.text = _selectedYear.toString();
  } else {
    _yearController.text = '';
  }
}


    return Scaffold(
      
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
                             Image.asset(
                                 'assets/doc.jpg',
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                             
                              SizedBox(height: 9), // espacio entre botones

                              Text('Número de cédula profesional', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             
                              SizedBox(height: 10), // espacio entre botones

                              //Numero de cédula
                              ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 300),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Número de cédula',
                                          hintText: '',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                          suffixIcon: Icon(Icons.numbers),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          //LengthLimitingTextInputFormatter(10),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ingrese su numero de cédula';
                                          }
                                          final cleanPhone = value.replaceAll(' ', '');
                                          //if (cleanPhone.length != 10) {
                                            //return 'Deben ser 10 dígitos';
                                          //}
                                          if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
                                            return 'Solo números permitidos';
                                          }
                                          return null;
                              },
                               ),
                              ),


                            //Institucion
                             SizedBox(height: 9), // espacio entre botones
                              Text('Institución', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             
                              SizedBox(height: 10), // espacio entre botones
                              // Campo de texto para el usuario
                              ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 300), // Ancho máximo
                                      child: TextField(
                                             decoration: InputDecoration(
                                                 labelText: 'Institución',
                                                  hintText: '',
                                                  border: OutlineInputBorder(),
                                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                  suffixIcon: Icon(Icons.school),
                                             ),
                                      ),
                              ),

                              //Tipo
                             SizedBox(height: 9), // espacio entre botones
                              Text('Tipo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             
                              SizedBox(height: 10), // espacio entre botones
                              // Campo de texto para el usuario
                              ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 300), // Ancho máximo
                                      child: TextField(
                                             decoration: InputDecoration(
                                                 labelText: 'Tipo',
                                                  hintText: '',
                                                  border: OutlineInputBorder(),
                                                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                  suffixIcon: Icon(Icons.badge),
                                             ),
                                      ),
                              ),
                              


                              //Año
                                                            //Tipo
                             SizedBox(height: 9), // espacio entre botones
                              Text('Año', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                             
                              SizedBox(height: 10), // espacio entre botones
                              ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: 300),
                                      child: TextFormField(
                                        controller: _yearController,
                                        decoration: InputDecoration(
                                          labelText: 'Año de nacimiento',
                                          hintText: 'AAAA',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () => _selectYear(context),
                                          ),
                                        ),
                                        readOnly: true,
                                        onTap: () => _selectYear(context),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor seleccione el año';
                                          }
                                          final year = int.tryParse(value);
                                          if (year == null || year < 1900 || year > DateTime.now().year) {
                                            return 'Ingrese un año válido';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                            
          ],
        ),
      ),
    );
  }  
}

class FormularioCedula extends StatefulWidget {
  final TextEditingController cedulaController;
  final TextEditingController institucionController;
  final TextEditingController tipoController;
  final TextEditingController yearController;
  final VoidCallback onSelectYear;

  const FormularioCedula({
    super.key,
    required this.cedulaController,
    required this.institucionController,
    required this.tipoController,
    required this.yearController,
    required this.onSelectYear,
  });

  @override
  State<FormularioCedula> createState() => _FormularioCedulaState();
}

class _FormularioCedulaState extends State<FormularioCedula> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo Cédula
            const Text('Número de cédula profesional', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.cedulaController,
              decoration: const InputDecoration(
                labelText: 'Número de cédula',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Ingrese su número de cédula';
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Solo números permitidos';
                return null;
              },
            ),

            // Campo Institución
            const SizedBox(height: 16),
            const Text('Institución', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.institucionController,
              decoration: const InputDecoration(
                labelText: 'Institución',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.school),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Ingrese la institución' : null,
            ),

            // Campo Tipo
            const SizedBox(height: 16),
            const Text('Tipo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.tipoController,
              decoration: const InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.badge),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Ingrese el tipo' : null,
            ),

            // Campo Año (con selector de fecha)
            const SizedBox(height: 16),
            const Text('Año', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.yearController,
              decoration: InputDecoration(
                labelText: 'Año',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: widget.onSelectYear,
                ),
              ),
              readOnly: true,
              onTap: widget.onSelectYear,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Seleccione el año';
                final year = int.tryParse(value);
                if (year == null || year < 1900 || year > DateTime.now().year) {
                  return 'Año inválido';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}