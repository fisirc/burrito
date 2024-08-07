import 'package:burrito_driver_app/start/inicio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DriverApp());
}

class DriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burrito Driver App',
      home: Scaffold(
        body: Center(
          child: BotonSolicitudes(),
        ),
      ),
    );
  }
}
