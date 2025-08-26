import 'package:app_corazon/models/Paciente.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Usuario.dart';
import '../utils/recursos_Campos.dart';



class MisPacientes_Widget extends StatefulWidget {
  Usuario usuario;
  List<Paciente> list = [];

  MisPacientes_Widget({
    super.key,
    required this.usuario,
    required this.list,
  });

  @override
  State<MisPacientes_Widget> createState() => _MisPacientes_Widget_State();
}

class _MisPacientes_Widget_State extends State<MisPacientes_Widget> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  String? _error;

  final _nombreCtrl = TextEditingController();

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

  List<Paciente> _applyFilters() {
    final query = _nombreCtrl.text.toLowerCase().trim();
    if (query.isEmpty) return widget.list;
    return widget.list.where((p) => p.name.toLowerCase().contains(query)).toList();
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
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  hintText: 'Buscar Paciente',
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (txt) {
                  setState(() {}); // refrescar para filtrar en vivo
                },
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

    final filtered = _applyFilters();

    if (filtered.isEmpty) {
      return const Center(child: Text("No se encontraron pacientes"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final p = filtered[i];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
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
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {},
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
         titulo('Mis pacientes', Icon(Icons.list, color: Colors.blueAccent)),
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