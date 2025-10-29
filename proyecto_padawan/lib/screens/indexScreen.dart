import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_padawan/components/menuNavegacion.dart';
import 'package:proyecto_padawan/pages/agendaPage.dart';
import 'package:proyecto_padawan/pages/customPaintPage.dart';
import 'package:proyecto_padawan/pages/indexPage.dart';
import 'package:proyecto_padawan/pages/notificacionesPushPage.dart';
import 'package:proyecto_padawan/pages/programarActividadPage.dart';
import 'package:proyecto_padawan/src/providers/push_notification_provider.dart';

import 'package:proyecto_padawan/services/notification_services.dart';

class Indexscreen extends StatefulWidget {
  const Indexscreen({super.key});

  @override
  State<Indexscreen> createState() => _IndexscreenState();
}

class _IndexscreenState extends State<Indexscreen> {
  int screenindex = 0;
  StreamSubscription? _notificationClickSubscription;

  late final List<Widget> pantallas = [
    const Indexpage(),
    const Custompaintpage(),
    Notificacionespushpage(
      mensajeNotificacion: NotificationServices().payloadDisplayStream,
    ),
    const Programaractividadpage(),
    const AgendaPage(),
  ];

  @override
  void initState() {
    super.initState();
    PushNotificationProvider().initNotification();
    _listenToNotificationClicks();
    _setupFirebaseListeners();
  }

  void _listenToNotificationClicks() {
    _notificationClickSubscription = NotificationServices()
        .notificationClickStream
        .listen((String payload) {
          print('Clic LOCAL detectado: Navegando y pasando payload...');

          if (mounted) {
            setState(() {
              screenindex = 2;
            });
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              NotificationServices().sendPayloadToDisplay(payload);
            }
          });
        });
  }

  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje mientras la app esta abierta ');
      if (message.notification != null) {
        NotificationServices().showFirebaseNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensaje mientras la app esta en segundo plano');
      final String? payload = message.data['Mensaje'];
      if (payload != null) {
        if (mounted) {
          setState(() {
            screenindex = 2;
          });
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            NotificationServices().sendPayloadToDisplay(payload);
          }
        });
      }
    });
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      print('La app se abrio desde un estado TERMINADO por una notificacion:');
      final String? payload = initialMessage.data['Mensaje'];
      if (payload != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              screenindex = 2;
            });
            NotificationServices().sendPayloadToDisplay(payload);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _notificationClickSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String titulo = destinations[screenindex].label;

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      drawer: Menunavegacion(
        selectedIndex: screenindex,
        onDestinationSelected: (int index) {
          setState(() {
            screenindex = index;
          });
          Navigator.pop(context);
        },
      ),
      body: pantallas[screenindex],
    );
  }
}

const List<Destination> destinations = [
  Destination(label: 'Inicio'),
  Destination(label: 'Dibujo'),
  Destination(label: 'Notificaciones'),
  Destination(label: 'Programar'),
  Destination(label: 'Agenda'),
];

class Destination {
  final String label;
  const Destination({required this.label});
}
