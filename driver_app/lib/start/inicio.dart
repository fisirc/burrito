// ignore_for_file: avoid_print
import 'package:burrito_driver_app/ending/final.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BotonSolicitudes extends StatefulWidget {
  const BotonSolicitudes({super.key});

  @override
  BotonSolicitudesState createState() => BotonSolicitudesState();
}

class BotonSolicitudesState extends State<BotonSolicitudes> {
  Timer? _timer;
  bool _isRunning = false;
  int _selectedStatus = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Función para realizar las solicitudes periódicamente
  void _startRequests() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isRunning) {
        timer.cancel();
      } else {
        await _hacerSolicitudes();
      }
    });
  }

  // Función para detener las solicitudes periódicas
  void _stopRequests() {
    _timer?.cancel();
    setState(() {
      // _mensaje = 'Solicitudes detenidas';
      _isRunning = false;
    });
  }

  // Función para hacer la solicitud POST
  Future<void> _hacerSolicitudes() async {
    Position? position;
    try {
      // Obtener la ubicación actual
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }

    if (position != null) {
      final urlPost = Uri.parse('http://elenadb.live:6969/give-position');
      // final urlPost = Uri.parse(
      //   'https://burrito-server.shuttleapp.rs/give-position',
      // );

      try {
        // Datos para enviar en la solicitud POST
        final postData = {
          'lt': position.latitude,
          'lg': position.longitude,
          'sts': _selectedStatus,
        };

        // Realizar la solicitud POST
        final response = await http.post(
          urlPost,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // final responseData = jsonDecode(response.body);
          // print('POST request data: $responseData');

          setState(() {
            // _mensaje = '¡Solicitud POST exitosa!';
          });
          // show snackbar of success
          if (context.mounted) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Solicitud enviada correctamente'),
                backgroundColor: Colors.green,
                duration: Duration(milliseconds: 500),
              ),
            );
          }
        } else {
          print('Error en POST request: ${response.statusCode}');
          setState(() {
            // _mensaje = 'Error en POST request';
          });
        }
      } catch (e, st) {
        print('Excepción atrapada: $e $st');
        setState(() {
          // _mensaje = 'Ocurrió un error';
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en la solicitud: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(milliseconds: 500),
            ),
          );
        }
      }
    } else {
      setState(() {
        // _mensaje = 'No se pudo obtener la ubicación';
      });
    }
  }

  void _navigateToStatusButton() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatusButton(
          onStop: _stopRequests,
          currentStatus: _selectedStatus, // Pasar el estado actual
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedStatus = result; // Actualizar el estado seleccionado
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Burrito Driver App',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Koulen',
                  ),
                ),
                const SizedBox(
                    height: 90), // Espacio entre el título y la imagen
                Image.asset(
                  'assets/img/real_burrito_icon.png', // Ruta de tu imagen
                  width: 340, // Ancho de la imagen
                  height: 340, // Alto de la imagen
                ),
                const SizedBox(
                    height: 130), // Espacio entre la imagen y el boton
              ],
            ),
            Center(
              child: SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRunning = true;
                      _startRequests();
                    });
                    _navigateToStatusButton();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Iniciar Recorrido',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
