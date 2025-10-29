import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_padawan/models/actividad_model.dart';

class ActivityCard extends StatelessWidget {
  final ActividadModel actividad;

  const ActivityCard({Key? key, required this.actividad}) : super(key: key);

  static const Map<String, Color> _coloresActividad = {
    'deporte': Color(0xFF4A90E2),
    'Estudiar': Color(0xFF50E3C2),
    'trabajo': Color(0xFFF5A623),
    'Ocio': Color(0xFF9013FE),
    'default': Colors.grey,
  };

  static const Map<String, IconData> _iconosActividad = {
    'deporte': Icons.fitness_center,
    'Estudiar': Icons.school_outlined,
    'trabajo': Icons.work_outline,
    'Ocio': Icons.videogame_asset_outlined,
    'default': Icons.task_alt,
  };
  Color get color =>
      _coloresActividad[actividad.tipo] ?? _coloresActividad['default']!;
  IconData get icono =>
      _iconosActividad[actividad.tipo] ?? _iconosActividad['default']!;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      child: Card(
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: color.withOpacity(0.7), width: 1.5),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.05), Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icono, color: Colors.white, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('HH:mm').format(actividad.fechaHora),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    actividad.tipo,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
