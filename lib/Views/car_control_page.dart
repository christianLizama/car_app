import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:car_app/Views/wifi_connect_page.dart';
import 'package:car_app/Views/car_procontrol_page.dart';


class ControlScreen extends StatefulWidget {
  final String esp32Ip;

  const ControlScreen({super.key, required this.esp32Ip});

  @override
  createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  Future<void> enviarComando(String action) async {
    final url = Uri.parse(
        'http://${widget.esp32Ip}/move'); // Reemplaza con la IP de tu ESP32
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              // enviarComando('camera');
              print('Mostrar contenido de la cámara');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/foto2.webp'), // Ruta de la imagen
                  fit: BoxFit
                      .cover,
                ),
              ),
              child:
                  null, // Puedes omitir child si solo quieres la imagen de fondo
            ),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Configurar Wifi'),
              onTap: () {
                // Acción para la opción 1
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WiFiScreen()),
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuraciones'),
              onTap: () {
                // Acción para la opción 2
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Ayuda'),
              onTap: () {
                // Acción para la opción 3
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Control Pro'),
              onTap: () {
                // Acción para la opción 4
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProControlScreen(esp32Ip: widget.esp32Ip);
                }));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Parte vertical de la cruz
            Container(
              width: 50,
              height: 170,
              color: Colors.lightBlue[100],
            ),
            // Parte horizontal de la cruz
            Container(
              width: 170,
              height: 50,
              color: Colors.lightBlue[100],
            ),
            // Área pulsable superior
            Positioned(
              top: 0,
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  enviarComando('backward');
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Área pulsable inferior
            Positioned(
              bottom: 0,
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  enviarComando('forward');
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Área pulsable izquierda
            Positioned(
              left: 0,
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  enviarComando('left');
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Área pulsable derecha
            Positioned(
              right: 0,
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  enviarComando('right');
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            // Área pulsable detenerse
            GestureDetector(
              onTap: () {
                enviarComando('stop');
              },
              child: Container(
                width: 40,
                height: 40,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const Text(
                  "Stop",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // enviarComando('light');
          print('Encender/Apagar luz');
        },
        child: const Icon(Icons.lightbulb_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
