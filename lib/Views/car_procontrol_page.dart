import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'camera_stream_widget.dart';
import 'package:car_app/Views/car_control_page.dart';
import 'package:car_app/Views/help_page.dart';

class ProControlScreen extends StatefulWidget {
  final String esp32Ip;

  const ProControlScreen({super.key, required this.esp32Ip});

  @override
  createState() => _ProControlScreenState();
}

class _ProControlScreenState extends State<ProControlScreen> {
  bool isLightOn = false;

  void toggleLight() {
    setState(() {
      isLightOn = !isLightOn;
      enviarComando(isLightOn ? 'light_on' : 'light_off');
    });
  }

  Future<void> enviarComando(String action) async {
    final url = Uri.parse('http://${widget.esp32Ip}/move');
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

  void _onJoystickMoved(StickDragDetails details) {
    if (details.x == 0 && details.y == 0) {
      enviarComando('stop');
    } else {
      if (details.x.abs() > details.y.abs()) {
        if (details.x > 0) {
          enviarComando('right');
        } else {
          enviarComando('left');
        }
      } else {
        if (details.y > 0) {
          enviarComando('forward');
        } else {
          enviarComando('backward');
        }
      }
      if (details.x > 0 && details.y < 0) {
        enviarComando('forward_right');
      } else if (details.x < 0 && details.y < 0) {
        enviarComando('forward_left');
      } else if (details.x > 0 && details.y > 0) {
        enviarComando('backward_right');
      } else if (details.x < 0 && details.y > 0) {
        enviarComando('backward_left');
      }
    }
  }

  void _sendCommandWhilePressed(String command) {
    enviarComando(command);
    Future.delayed(Duration(milliseconds: 100), () {
      if (_buttonPressed) {
        _sendCommandWhilePressed(command);
      }
    });
  }

  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context);

    // Check if the screen is in landscape mode
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/foto2.webp'), // Ruta de la imagen
                  fit: BoxFit.cover,
                ),
              ),
              child:
                  null, // Puedes omitir child si solo quieres la imagen de fondo
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Ayuda'),
              onTap: () {
                // Acción para la opción 3
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HelpView();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.gamepad),
              title: const Text('Control Simple'),
              onTap: () {
                // Acción para la opción 4
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ControlScreen(esp32Ip: widget.esp32Ip);
                }));
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            if (isLandscape) ...[
              // Widget de stream de la cámara
              Positioned.fill(
                child: CameraStreamWidget(url: 'ws://${widget.esp32Ip}:81'),
              ),
              // Botón de menú
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    color: Colors.white,
                    iconSize: 40.0,
                  ),
                ),
              ),
              // Joystick
              Positioned(
                bottom: 16.0,
                left: 16.0,
                child: Joystick(
                  base: JoystickBase(
                    decoration: JoystickBaseDecoration(
                      middleCircleColor:
                          const Color.fromARGB(255, 186, 181, 181),
                      drawOuterCircle: false,
                      drawInnerCircle: false,
                      boxShadowColor: const Color.fromARGB(0, 136, 115, 117),
                    ),
                    arrowsDecoration: JoystickArrowsDecoration(
                      color: Colors.grey,
                      enableAnimation: false,
                    ),
                  ),
                  stick: JoystickStick(
                    decoration: JoystickStickDecoration(
                      color: const Color.fromARGB(255, 183, 179, 179),
                    ),
                  ),
                  listener: _onJoystickMoved,
                ),
              ),
              // Botones en la esquina inferior derecha
              Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Column(
                  children: [
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          isLightOn
                              ? Icons.lightbulb
                              : Icons.lightbulb_outline,
                        ),
                        onPressed: toggleLight,
                        iconSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        GestureDetector(
                          onLongPressStart: (_) {
                            _buttonPressed = true;
                            _sendCommandWhilePressed('left');
                          },
                          onLongPressEnd: (_) {
                            _buttonPressed = false;
                            enviarComando('stop');
                          },
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.rotate_left,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        GestureDetector(
                          onLongPressStart: (_) {
                            _buttonPressed = true;
                            _sendCommandWhilePressed('right');
                          },
                          onLongPressEnd: (_) {
                            _buttonPressed = false;
                            enviarComando('stop');
                          },
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.rotate_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (!isLandscape)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Text(
                      'Por favor, gire la pantalla',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
