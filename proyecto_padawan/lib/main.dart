import 'package:flutter/material.dart';
import 'package:proyecto_padawan/controllers/agenda_controller.dart';
import 'package:proyecto_padawan/screens/indexScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_padawan/services/notification_services.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String taskName = 'RecordatorioAgendaTask';
const String inputDataKey = 'actividadTitulo';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationServices().init();
  await NotificationServices().requestPermisions();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AgendaController());
    return GetMaterialApp(
      supportedLocales: const [Locale('en', ''), Locale('es', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: const Indexscreen()),
    );
  }
}
