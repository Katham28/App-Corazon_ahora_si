import 'package:flutter/material.dart';

class Pantalla_Crear_cuenta extends StatelessWidget {
  const Pantalla_Crear_cuenta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear cuenta',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,  // Espaciado entre letras
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
        toolbarHeight: 70,  // Altura personalizada de la AppBar
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
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PIniciarSesion()),
                      ); */
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
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PCrearCuenta()),
                      ); */
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
                TextButton(
                  onPressed: () {
                    // Acción para "¿Olvidaste tu contraseña?"
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}