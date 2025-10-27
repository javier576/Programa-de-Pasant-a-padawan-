import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_padawan/components/menuNavegacion.dart';
import 'package:proyecto_padawan/pages/customPaintPage.dart';
import 'package:proyecto_padawan/pages/indexPage.dart';
import 'package:proyecto_padawan/pages/notificacionesPushPage.dart';
//import 'package:proyecto_padawan/src/providers/push_notification_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Indexscreen extends StatefulWidget {
  const Indexscreen({super.key});

  @override
  State<Indexscreen> createState() => _IndexscreenState();
}

class _IndexscreenState extends State<Indexscreen> {
  int screenindex = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final mensajeStreamController = StreamController<String>.broadcast();

  Stream<String> get mensajes => mensajeStreamController.stream;
  late final List<Widget> pantallas = [
    const Indexpage(),
    const Custompaintpage(),
    Notificacionespushpage(mensajeNotificacion: mensajeStreamController.stream),
  ];

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Click en notificacion local');
        handleNotificationClick(response.payload);
      },
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showLocalNotification(RemoteMessage message) async {
    final String? title = message.notification?.title;
    final String? body = message.notification?.body;
    final String? payload = message.data['Mensaje'];
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'Este canal se usa para notificaciones importantes.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  void initState() {
    super.initState();
    initializeLocalNotifications();
    //final pushProvider = PushNotificationProvider();
    //pushProvider.initNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje mientras la app esta  abierta ');
      print('Datos del mensaje: ${message.data}');
      String argumento = 'no-data';

      if (Platform.isAndroid) {
        argumento = message.data['Mensaje'] ?? 'Datos no Encontrados';
      }
      mensajeStreamController.sink.add(argumento);

      if (message.notification != null) {
        showLocalNotification(message);

        print(
          'El mensaje tambien contenia una notificacion: ${message.notification!.title}',
        );
      }

      if (mounted) {
        handleNotificationClick(argumento);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensaje mientras la app esta  en segundo plano');
      print('Datos del mensaje: ${message.data}');
      handleNotificationClick(message.data['Mensaje']);
    });

    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      print('La app se abrio desde un estado TERMINADO por una notificacion:');
      print('Datos del mensaje: ${initialMessage.data}');

      handleNotificationClick(initialMessage.data['Mensaje']);
    }
  }

  void handleNotificationClick(String? payload) {
    print('Manejando clic de notificacion y navegando...');
    final String argumento = payload ?? 'Datos no encontrados';

    if (mounted) {
      setState(() {
        screenindex = 2;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        mensajeStreamController.sink.add(argumento);
      }
    });
  }

  @override
  void dispose() {
    mensajeStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(destinations[screenindex].label)),
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
