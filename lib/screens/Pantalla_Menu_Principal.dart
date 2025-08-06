import 'package:flutter/material.dart';
import '../screens/Pantalla_Crear_cuenta.dart';
import '../screens/Pantalla_Iniciar_sesion.dart';
import '../services/mongo.dart';

class MenuPrincipal extends StatelessWidget {
  MenuPrincipal({super.key});
  final MongoService mongoService = MongoService();

  Future<void> _testMongoConnection(BuildContext context) async {
    try {
      // Conectar a MongoDB
      await mongoService.connect();
      
      // Insertar un documento de prueba
      final insertResult = await mongoService.insertOne('Medico', {
        'nombre': 'Usuario Prueba',
        'email': 'prueba@example.com',
        'fecha': DateTime.now()
      });

      // Mostrar resultado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Documento insertado con ID: ${insertResult.id}'),
          backgroundColor: Colors.green,
        )
      );
      
      // Buscar documentos
      final usuarios = await mongoService.find('usuarios');
      print('Usuarios encontrados: ${usuarios.length}');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        )
      );
    } finally {
      // Cerrar conexión
      await mongoService.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú Principal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shadowColor: Colors.blue[800],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        toolbarHeight: 70,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/cor.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Pantalla_Iniciar_sesion()),
                      ); 
                    },
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
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Pantalla_Crear_cuenta()),
                      ); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blueAccent, width: 2),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}