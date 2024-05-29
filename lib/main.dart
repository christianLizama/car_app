import 'package:flutter/material.dart';
import 'package:car_app/Views/wifi_connect_page.dart';

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
