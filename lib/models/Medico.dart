import 'Usuario.dart';
import 'Paciente.dart';

class Medico extends Usuario {
  List<Paciente> _listadoPacientes = [];
  int cedula;

  void addPaciente(Paciente paciente) {
    _listadoPacientes.add(paciente);
  }
  void removePaciente(Paciente paciente) {
    _listadoPacientes.remove(paciente);
  }

  List<Paciente> get listadoPacientes => _listadoPacientes;

  
Medico({
    required String name,
    required String app_pat,
    required String app_mat,
    required String email,
    required String password,
    required String type_user,
    required DateTime fecha_nacimiento,
    required int telefono,
     required int cedula,
    List<Paciente>? listadoPacientes,  // Parámetro opcional

  }) : _listadoPacientes = listadoPacientes ?? [],  // Asigna lista vacía si es null
        cedula = cedula,
        super(
          name: name,
          app_pat: app_pat,
          app_mat: app_mat,
          email: email,
          password: password,
          type_user: type_user,
          fecha_nacimiento: fecha_nacimiento,
          telefono: telefono,
        );
  



  /* ╭───── JSON ─────╮ */
  factory Medico.fromJson(Map<String, dynamic> j) => Medico(
        name: j['n']?.toString() ?? '',
        app_pat: j['ap']?.toString() ?? '',
        app_mat: j['am']?.toString() ?? '',
        email: j['e']?.toString() ?? '',
        password: j['p']?.toString() ?? '',
        type_user: j['ty']?.toString() ?? '',
        fecha_nacimiento: DateTime.tryParse(j['f']?.toString() ?? '') ?? DateTime(0),
        telefono: (j['t'] as num?)?.toInt() ?? 0,
        cedula: (j['c'] as num?)?.toInt() ?? 0,
      );

  @override
  Map<String, dynamic> toJson() => {
        'n': name,
        'ap': app_pat,
        'am': app_mat,
        'e': email,
        'p': password,
        'ty': type_user,
        'f': fecha_nacimiento.toIso8601String(),
        't': telefono,
        'c': cedula,
      };
}