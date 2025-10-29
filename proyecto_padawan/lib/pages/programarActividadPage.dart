import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_padawan/controllers/agenda_controller.dart';
import 'package:proyecto_padawan/models/actividad_model.dart';
import 'package:proyecto_padawan/services/notification_services.dart';
import 'package:get/get.dart';

class Programaractividadpage extends StatefulWidget {
  const Programaractividadpage({super.key});

  @override
  State<Programaractividadpage> createState() => _ProgramaractividadpageState();
}

class _ProgramaractividadpageState extends State<Programaractividadpage> {
  final List<String> _tiposDeActividad = [
    'deporte',
    'Estudiar',
    'trabajo',
    'Ocio',
  ];
  String? _actividadSeleccionada;
  DateTime? tiempoSeleccionado;

  @override
  void initState() {
    super.initState();
  }

  Future<void> seleccionarFechaYHora() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (fecha == null) return;
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (hora == null) return;
    setState(() {
      tiempoSeleccionado = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      );
    });
  }

  void programarNotification() async {
    if (_actividadSeleccionada == null || tiempoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecciona una actividad y una fecha y hora',
          ),
        ),
      );
      return;
    }
    if (tiempoSeleccionado!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha y hora seleccionada ya pasó.')),
      );
      return;
    }
    final int id = DateTime.now().microsecondsSinceEpoch % 100000;
    final String titulo = _actividadSeleccionada!;

    final nuevaActividad = ActividadModel(
      tipo: titulo,
      fechaHora: tiempoSeleccionado!,
      notificationId: id,
    );

    final agendaController = Get.find<AgendaController>();
    agendaController.agregarActividad(nuevaActividad);
    await NotificationServices().scheduleNotification(
      id: id,
      title: titulo,
      body: 'Recordatorio de actividad',
      payload: 'actvidad_programada_${titulo.toLowerCase()}_$id',
      scheduledDate: tiempoSeleccionado!,
    );
    print('Notficacion Programada para: $tiempoSeleccionado ');
    setState(() {
      _actividadSeleccionada = null;
      tiempoSeleccionado = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recordatorio Programado con exito!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: _actividadSeleccionada,
                  hint: const Text('Selecciona una actividad'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _tiposDeActividad.map((String actividad) {
                    return DropdownMenuItem<String>(
                      value: actividad,
                      child: Text(actividad),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _actividadSeleccionada = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tiempoSeleccionado == null
                            ? 'No has seleccionado fecha y hora'
                            : DateFormat(
                                'EEE, d MMM, hh:mm a',
                              ).format(tiempoSeleccionado!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: seleccionarFechaYHora,
                      child: const Text('Seleccionar'),
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
        ),
      ),
    );
  }
}
