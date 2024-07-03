import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car_app/Views/car_control_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return const MaterialApp(
      home: ControlScreen(esp32Ip: "192.168.4.1"),
    );
  }
}
