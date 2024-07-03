import 'package:flutter/material.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: const Center(
        // ignore: unnecessary_const
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Instrucciones de conexión:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. Conéctese a la red WiFi:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '   Nombre: auto',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '   Contraseña: 12345678',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '2. Vuelva atrás para controlar el dispositivo.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
