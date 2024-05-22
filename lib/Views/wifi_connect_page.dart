import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'car_control_page.dart';

class WiFiConnectPage extends StatefulWidget {
  const WiFiConnectPage({super.key});

  @override
  createState() => _WiFiConnectPageState();
}

class _WiFiConnectPageState extends State<WiFiConnectPage> {
  final TextEditingController _ssidController = TextEditingController(text: 'MiRedESP32');
  final TextEditingController _passwordController = TextEditingController(text: '12345678');

  void _connectToWiFi() async {
    String ssid = _ssidController.text;
    String password = _passwordController.text;

    bool connected = await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
    );

    if (!mounted) return;

    if (connected) {
      String? ipAddress = await WiFiForIoTPlugin.getIP();
      print('Connected to WiFi. IP Address: $ipAddress');
      
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarControlPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al conectar a $ssid')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexión WiFi ESP32'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(labelText: 'SSID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connectToWiFi,
              child: const Text('Conectar'),
            ),
          ],
        ),
      ),
    );
  }
}
