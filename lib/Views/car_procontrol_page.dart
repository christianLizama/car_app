import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/foto1.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Botón de menú
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
              color: Colors.white,
              iconSize: 40.0,
            ),
          ),
          // Botón de cámara
          Positioned(
            top: 16.0,
            right: 16.0,
            child: IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {},
              color: Colors.white,
              iconSize: 40.0,
            ),
          ),
          // Joystick
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Joystick(
              base: JoystickBase(
                decoration: JoystickBaseDecoration(
                  middleCircleColor: const Color.fromARGB(255, 186, 181, 181),
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
              listener: (StickDragDetails details) {},
            ),
          ),
          // Botón verde en la esquina inferior derecha
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  isLightOn ? Icons.lightbulb : Icons.lightbulb_outline,
                ),
                onPressed: toggleLight,
                iconSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
