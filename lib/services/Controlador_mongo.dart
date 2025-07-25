import 'package:mongo_dart/mongo_dart.dart';
import '../services/mongo.dart';
import '../models/Usuario.dart';
import '../models/Medico.dart';

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