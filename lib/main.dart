import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WiFiScreen(),
    );
  }
}

class WiFiScreen extends StatefulWidget {
  const WiFiScreen({super.key});

  @override
  createState() => _WiFiScreenState();
}

class _WiFiScreenState extends State<WiFiScreen> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String esp32Ip = "192.168.4.1"; // IP por defecto del ESP32

  Future<void> enviarDatos(String ssid, String password) async {
    final url = Uri.parse('http://192.168.4.1/'); // Reemplaza con la IP de tu ESP32
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'ssid=$ssid&password=$password',
    );

    if (response.statusCode == 200) {
      if (!mounted) return;
      print('Datos enviados exitosamente!');
      // Navegar a la pantalla de controles
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ControlScreen(esp32Ip: esp32Ip)),
      );
    } else {
      print('Error al enviar datos: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar WiFi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(labelText: 'SSID'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                enviarDatos(ssidController.text, passwordController.text);
              },
              child: const Text('Conectar a WiFi'),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlScreen extends StatefulWidget {
  final String esp32Ip;

  const ControlScreen({super.key, required this.esp32Ip});

  @override
  createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  Future<void> enviarComando(String action) async {
    final url = Uri.parse('http://192.168.226.203/move'); // Reemplaza con la IP de tu ESP32
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'action=$action',
    );

    if (response.statusCode == 200) {
      print('Comando enviado exitosamente!');
    } else {
      print('Error al enviar comando: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control del Auto'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      const SizedBox(), // Espacio vacío
                      ElevatedButton(
                        onPressed: () {
                          enviarComando('backward');
                        },
                        child: const Text('Adelante'),
                      ),
                      const SizedBox(), // Espacio vacío
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          enviarComando('left');
                        },
                        child: const Text('Izquierda'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          enviarComando('stop');
                        },
                        child: const Text('Detenerse'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          enviarComando('right');
                        },
                        child: const Text('Derecha'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const SizedBox(), // Espacio vacío
                      ElevatedButton(
                        onPressed: () {
                          enviarComando('forward');
                        },
                        child: const Text('Atras'),
                      ),
                      const SizedBox(), // Espacio vacío
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
