import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:workmanagerprueba/screens/workmanagerScreen.dart';
import 'package:workmanagerprueba/services/notification_services.dart';

const String taskName = 'recordatorioAgendaTask';
const String inputDataKey = 'actividadTitulo';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == taskName) {
      print('workManager: Ejecutado tarea de agenda...');

      await NotificationService().init();

      String tituloActividad =
          inputData?[inputDataKey] ?? "Actividad Programada";

      int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await NotificationService().showNotification(
        notificationId,
        '¡Recordatorio de Actividad!',
        tituloActividad,
      );
      print("WorkManager: Notificacion Mostrada para '$tituloActividad'.");
      return Future.value(true);
    }
    return Future.value(false);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Agenda con Workmanager',
      home: Workmanagerscreen(),
    );
  }
}
