import 'package:mongo_dart/mongo_dart.dart';
import '../services/mongo.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';
import '../models/Paciente.dart';
import '../models/Registro.dart';
class Controlador_Mongo {
  final MongoService mongoService = MongoService();

  Future<void> connect() async {
    await mongoService.connect();
  }

  Future<void> disconnect() async {
    await mongoService.disconnect();
  }

  Future<WriteResult> insertOne(
      String collectionName, Map<String, dynamic> document) async {
    return await mongoService.insertOne(collectionName, document);
  }

  Future<WriteResult> insertUsuario(Usuario usuario) async {
    if (usuario == null) {
      throw ArgumentError('El usuario no puede ser nulo');
    }

    final collectionName = usuario.type_user == 'medico' ? 'Medico' : 'Paciente';
    final document = _createUserDocument(usuario);

    return await mongoService.insertOne(collectionName, document);
  }

  Future<int> findExistingUsuario(String correo) async {
    int band=0;
    print("buscando si existe: $correo");
   final resultadoPaciente = await mongoService.find('Paciente', {
        'email': correo,
      });

      final resultadoMedico= await mongoService.find('Medico', {
        'email': correo,
      });



      if (resultadoPaciente.isNotEmpty || resultadoMedico.isNotEmpty) {
        print('❌ Usuario preexistente');
        band=1;
      } else   {
        band=0; 
      }

    return await band;
  }

  Future<Usuario> findUsuario(Usuario usuario) async {
      Paciente? paciente;
      Medico? medico;

      final resultadoPaciente = await mongoService.find('Paciente', {
        'usuario': 'usuario.email',
      });

      final resultadoMedico= await mongoService.find('Medico', {
        'usuario': 'usuario.email',
      });

      if (resultadoPaciente.isNotEmpty ) {
        print('✅ Paciente encontrado: ${resultadoPaciente.first}');
        return await  usuarioFromMongoDoc(resultadoPaciente.first);
      
      } else if (resultadoMedico.isNotEmpty) {
        print('✅ Médico encontrado: ${resultadoMedico.first}');
        return await  usuarioFromMongoDoc(resultadoMedico.first);

      } 


    print('❌ Usuario no encontrado');
    return await  usuarioFromMongoDoc(resultadoPaciente.first);

  }

Usuario usuarioFromMongoDoc(Map<String, dynamic> doc) {
  final hasCedula = doc.containsKey('c') || doc.containsKey('cedula');

  if (hasCedula) {
        final pacientesDocs = doc['listadoPacientes'] as List<dynamic>? ?? [];
        final pacientes = pacientesDocs.map((p) => Paciente(
          name: p['name']?.toString() ?? '',
          app_pat: p['app_pat']?.toString() ?? '',
          app_mat: p['app_mat']?.toString() ?? '',
          email: p['email']?.toString() ?? '',
          password: '',
          type_user: p['type_user']?.toString() ?? '',
          fecha_nacimiento: DateTime.tryParse(p['fecha_nacimiento']?.toString() ?? '') ?? DateTime(0),
          telefono: (p['telefono'] as num?)?.toInt() ?? 0,
        )).toList();

        return Medico(
          name: doc['name']?.toString() ?? '',
          app_pat: doc['app_pat']?.toString() ?? '',
          app_mat: doc['app_mat']?.toString() ?? '',
          email: doc['email']?.toString() ?? '',
          password: doc['password']?.toString() ?? '',
          type_user: doc['type_user']?.toString() ?? '',
          fecha_nacimiento: DateTime.tryParse(doc['fecha_nacimiento']?.toString() ?? '') ?? DateTime(0),
          telefono: (doc['telefono'] as num?)?.toInt() ?? 0,
          cedula: (doc['c'] ?? doc['cedula']) as int,
          listadoPacientes: pacientes,
        );
  } else {
        final registrosDocs = doc['listadoRegistros'] as List<dynamic>? ?? [];
        final registros = registrosDocs.map((p) => Registro(
          aux_raw: (p['aux_raw'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          aux_time: (p['aux_time'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          bmp_time: (p['bmp_time'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          bmp_raw: (p['bmp_raw'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          egc_time: (p['egc_time'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          egc_raw: (p['egc_raw'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          ppg_time: (p['ppg_time'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          ppg_raw: (p['ppg_raw'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ?? [],
          dateTime: DateTime.tryParse(p['dateTime']?.toString() ?? '') ?? DateTime(0),
        )).toList();

    return Paciente(
      name: doc['name']?.toString() ?? '',
      app_pat: doc['app_pat']?.toString() ?? '',
      app_mat: doc['app_mat']?.toString() ?? '',
      email: doc['email']?.toString() ?? '',
      password: doc['password']?.toString() ?? '',
      type_user: doc['type_user']?.toString() ?? '',
      fecha_nacimiento: DateTime.tryParse(doc['fecha_nacimiento']?.toString() ?? '') ?? DateTime(0),
      telefono: (doc['telefono'] as num?)?.toInt() ?? 0,

    );
  }
}


  Map<String, dynamic> _createUserDocument(Usuario usuario) {
    final baseDocument = {
      'name': usuario.name,
      'app_pat': usuario.app_pat,
      'app_mat': usuario.app_mat,
      'fecha_nacimiento': usuario.fecha_nacimiento.toIso8601String(),
      'email': usuario.email,
      'password': usuario.password,
      'type_user': usuario.type_user,
      'telefono': usuario.telefono,
    };

    if (usuario is Medico) {
      baseDocument.addAll({
        'cedula': (usuario as Medico).cedula,
        'listadoPacientes': [],
      });
    } else {
      baseDocument.addAll({
        'listadoRegistros': [],
      });
    }

    return baseDocument;
  }

  Future<BulkWriteResult> insertMany(
      String collectionName, List<Map<String, dynamic>> documents) async {
    return await mongoService.insertMany(collectionName, documents);
  }

  Future<List<Map<String, dynamic>>> find(
      String collectionName, [Map<String, dynamic>? filter]) async {
    return await mongoService.find(collectionName, filter);
  }

  Future<WriteResult> deleteOne(
      String collectionName, Map<String, dynamic> filter) async {
    return await mongoService.deleteOne(collectionName, filter);
  }

  Future<int> count(String collectionName, [Map<String, dynamic>? filter]) async {
    return await mongoService.count(collectionName, filter);
  }
}