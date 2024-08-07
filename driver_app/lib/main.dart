import 'package:burrito_driver_app/start/inicio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Burrito Driver App',
      home: Scaffold(
        body: Center(
          child: BotonSolicitudes(),
        ),
      ),
    );
  }
}
