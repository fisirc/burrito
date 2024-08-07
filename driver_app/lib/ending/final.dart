import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget {
  final VoidCallback onStop;
  final int currentStatus;

  const StatusButton({
    super.key,
    required this.onStop,
    required this.currentStatus,
  });

  @override
  StatusButtonState createState() => StatusButtonState();
}

class StatusButtonState extends State<StatusButton> {
  late int _selectedStatus;

  // Mapa de estados con sus descripciones
  final Map<int, String> _statusDescriptions = {
    0: 'En ruta',
    1: 'Fuera de servicio',
    2: 'En descanso',
    3: 'Accidente',
  };

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
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
                Image.asset(
                  'assets/img/real_burrito_icon.png',
                  width: 340,
                  height: 340,
                ),
                const SizedBox(height: 130),
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 260,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Selecciona el Estado'),
                              content: DropdownButton<int>(
                                value: _selectedStatus,
                                items: _statusDescriptions.entries.map((entry) {
                                  return DropdownMenuItem<int>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _selectedStatus = newValue!;
                                  });
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Aceptar'),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        _selectedStatus); // Pasar el estado seleccionado
                                  },
                                ),
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Cerrar el modal sin seleccionar
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((selectedStatus) {
                          if (selectedStatus != null) {
                            setState(() {
                              _selectedStatus = selectedStatus;
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _statusDescriptions[_selectedStatus] ??
                            'Estado Desconocido',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onStop();
                        Navigator.pop(context,
                            _selectedStatus); // Pasar el estado seleccionado
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(Icons.stop),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
