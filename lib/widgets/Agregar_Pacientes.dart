import 'package:app_corazon/models/Paciente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
import '../utils/recursos_Campos.dart';



class AgregarPacientes_Widget extends StatefulWidget {
  Usuario usuario;
  List<Paciente> list = [];


  AgregarPacientes_Widget({
    super.key,
    required this.usuario,
    required this.list,
  });

  @override
  State<AgregarPacientes_Widget> createState() => _AgregarPacientes_Widget_State();
}

class _AgregarPacientes_Widget_State extends State<AgregarPacientes_Widget> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  int _hoveredIndex = -1; //para resaltar la fila al pasar el mouse
  String? _error;

  final _nombreCompletoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAndFetch();
  }

  Future<void> _initAndFetch() async {
    await _fetch();
  }

  void actualizar_listado_pacientes(List<Paciente> nuevosPacientes) {
    setState(() {
      widget.list = nuevosPacientes;
    });
  }

  Future<void> _fetch() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // simulación de espera
      // 🔹 Lista de prueba (simulación)
    } catch (e) {
      _error = 'Error inesperado: $e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

// BÚSQUEDA MEJORADA: Busca por separado en nombre, apellido paterno y materno
  List<Paciente> _applyFilters() {
    final query = _nombreCompletoCtrl.text.toLowerCase().trim();
    if (query.isEmpty) return widget.list;
    
    final searchTerms = query.split(' ').where((term) => term.isNotEmpty).toList();
    
    return widget.list.where((p) {
      // Buscar en cada campo por separado
      final nombre = p.name.toLowerCase();
      final apellidoPaterno = p.app_pat.toLowerCase();
      final apellidoMaterno = p.app_mat.toLowerCase();
      
      // Verificar que todos los términos de búsqueda coincidan en alguno de los campos
      for (final term in searchTerms) {
        final termMatches = nombre.contains(term) || 
                           apellidoPaterno.contains(term) || 
                           apellidoMaterno.contains(term);
        
        if (!termMatches) {
          return false;
        }
      }
      return true;
    }).toList();
  }




  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: null,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: null,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: TextField(
                controller: _nombreCompletoCtrl,
                decoration: const InputDecoration(
                  hintText: 'Buscar Paciente',
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                )
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              tooltip: 'Recargar',
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () async {
                setState(() => _loading = true);
                await _fetch();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
  if (_loading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (_error != null) {
    return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)));
  }
  if (widget.list.isEmpty) {
    return const Center(child: Text("No hay pacientes registrados"));
  }

  // Aplicar filtros de búsqueda
  final filtered = _applyFilters();
  if (filtered.isEmpty) {
    return const Center(child: Text("No se encontraron pacientes"));
  }
  
  // Construir la lista filtrada
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: filtered.length,
    itemBuilder: (context, i) {
      final p = filtered[i];
      
      return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = i),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: InkWell(
                onTap: () {
                  print("Paciente seleccionado: ${p.name} ${p.app_pat} ${p.app_mat}");

                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _hoveredIndex == i
                          ? [Colors.blue[100]!, Colors.lightBlue[200]!]
                          : [Colors.white, Colors.blue[50]!],
                    ),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      '${p.name} ${p.app_pat} ${p.app_mat}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${p.email}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: () {

                        print("Agregar paciente: ${p.name}");
                      },
                    ),
                  ),
                ),
              ),
            ),
          );

    },
  );
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
   
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[50]!, Colors.white],
        ),
      ),
      child: Column(

        children: [
        const SizedBox(height: 20),
         titulo('Agregar pacientes', Icon(Icons.list, color: Colors.blueAccent)),
          _buildSearchBar(),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    ),
  );
}

}