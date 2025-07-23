import 'package:mongo_dart/mongo_dart.dart';
import '../services/mongo.dart';

class Controlador_Mongo {
final MongoService mongoService = MongoService();

  Future<void> connect( ) async {
    mongoService.connect();
  }

  Future<void> disconnect() async {
    mongoService.disconnect();
  }

  // InsertOne retorna WriteResult
  Future<WriteResult> insertOne(
      String collectionName, Map<String, dynamic> document) async {
    return mongoService.insertOne(collectionName, document);
  }

  // InsertMany retorna BulkWriteResult
  Future<BulkWriteResult> insertMany(
      String collectionName, List<Map<String, dynamic>> documents) async {
    return mongoService.insertMany(collectionName, documents);
  }

  Future<List<Map<String, dynamic>>> find(
      String collectionName, [Map<String, dynamic>? filter]) async {
    return mongoService.find(collectionName, filter);

  }



  // DeleteOne retorna WriteResult
 Future<WriteResult> deleteOne(
      String collectionName, Map<String, dynamic> filter) async {
    return mongoService.deleteOne(collectionName, filter);
  }


  Future<int> count(String collectionName, [Map<String, dynamic>? filter]) async {
   return mongoService.count(collectionName, filter);
    
  }


}