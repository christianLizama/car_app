import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarControlPage extends StatefulWidget {
  const CarControlPage({super.key});

  @override
  createState() => _CarControlPageState();
}

class _CarControlPageState extends State<CarControlPage> {
  final TextEditingController _newSsidController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _sendCommand(String command) async {
    final response = await http.get(Uri.parse('http://192.168.4.1/$command'));

    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comando $command enviado')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al enviar comando $command')));
    }
  }

  void _sendWiFiCredentials() async {
    String newSsid = _newSsidController.text;
    String newPassword = _newPasswordController.text;

    final response = await http.post(
      Uri.parse('http://192.168.4.2/connect'),
      body: {
        'ssid': newSsid,
        'password': newPassword,
      },
    );
    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Configuración enviada: $newSsid')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al enviar configuración')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Auto ESP32'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _newSsidController,
                  decoration: const InputDecoration(labelText: 'Nuevo SSID'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(labelText: 'Nueva Contraseña'),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: _sendWiFiCredentials,
                child: const Text('Enviar Credenciales WiFi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
