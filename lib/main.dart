import 'package:flutter/material.dart';
import 'package:car_app/Views/wifi_connect_page.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return const MaterialApp(
      home: WiFiScreen(),
    );
  }
}
