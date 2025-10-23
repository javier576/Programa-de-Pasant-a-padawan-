import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanagerprueba/main.dart';
import 'package:workmanagerprueba/services/notification_services.dart';

class Workmanagerscreen extends StatefulWidget {
  const Workmanagerscreen({super.key});

  @override
  State<Workmanagerscreen> createState() => _WorkmanagerscreenState();
}

class _WorkmanagerscreenState extends State<Workmanagerscreen> {
  final TextEditingController actividadController = TextEditingController();
  DateTime? tiempoSeleccionado;

  @override
  void initState() {
    super.initState();
    NotificationService().requestPermissions();
  }

  void seleccionarHora() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      setState(() {
        tiempoSeleccionado = DateTime(
          now.year,
          now.month,
          now.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        if (tiempoSeleccionado!.isBefore(now)) {
          tiempoSeleccionado = tiempoSeleccionado!.add(const Duration(days: 1));
        }
      });
    }
  }

  void programarNotification() {
    if (actividadController.text.isEmpty || tiempoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por Favor, escribe una actividad y selecciona una hora',
          ),
        ),
      );
      return;
    }

    final Duration retraso = tiempoSeleccionado!.difference(DateTime.now());

    Workmanager().registerOneOffTask(
      "id_${taskName}_${tiempoSeleccionado!.microsecondsSinceEpoch}",
      taskName,
      inputData: <String, dynamic>{inputDataKey: actividadController.text},
      initialDelay: retraso,
    );
    print(
      "Notificacion programada para: $tiempoSeleccionado con retraso de: $retraso",
    );

    actividadController.clear();
    setState(() {
      tiempoSeleccionado = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recordatorio Programado con exito!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Programar Actividad")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: actividadController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la actividad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tiempoSeleccionado == null
                        ? 'No has seleccionado una hora'
                        : DateFormat(
                            'EEE, d MMM, hh:mm a',
                          ).format(tiempoSeleccionado!),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: seleccionarHora,
                  child: const Text('Seleccionar hora'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: programarNotification,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              child: const Text('Programar Recordatorio'),
            ),
          ],
        ),
      ),
    );
  }
}
