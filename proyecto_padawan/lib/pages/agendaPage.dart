import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_padawan/controllers/agenda_controller.dart';
import 'package:proyecto_padawan/components/widgetComponent.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgendaController controller = Get.find();

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              _DateNavigator(controller: controller),
              Expanded(
                child: Obx(() {
                  final actividades = controller.actividadesDelDia;

                  if (actividades.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay actividades para este día.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: actividades.length,
                    itemBuilder: (context, index) {
                      final actividad = actividades[index];
                      return ActivityCard(actividad: actividad);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateNavigator extends StatelessWidget {
  final AgendaController controller;

  const _DateNavigator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left_rounded, size: 32),
            onPressed: () => controller.cambiarDia(-1),
          ),
          Obx(() {
            final String fechaStr = DateFormat(
              'EEE, d MMM',
              'es_ES',
            ).format(controller.fechaSeleccionada.value);
            return Text(
              fechaStr,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            );
          }),
          IconButton(
            icon: const Icon(Icons.arrow_right_rounded, size: 32),
            onPressed: () => controller.cambiarDia(1),
          ),
        ],
      ),
    );
  }
}
