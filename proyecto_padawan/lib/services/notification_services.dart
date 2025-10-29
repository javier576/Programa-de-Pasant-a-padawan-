import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationServices {
  static final NotificationServices _notificationServices =
      NotificationServices._internal();
  factory NotificationServices() => _notificationServices;
  NotificationServices._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<String> _notificationClickController =
      StreamController<String>.broadcast();

  final StreamController<String> _payloadDisplayController =
      StreamController<String>.broadcast();

  Stream<String> get notificationClickStream =>
      _notificationClickController.stream;
  Stream<String> get payloadDisplayStream => _payloadDisplayController.stream;

  void sendPayloadToDisplay(String payload) {
    _payloadDisplayController.sink.add(payload);
  }

  static void _onNotificationClicked(NotificationResponse response) {
    print('Click en notificacion local detectado por el SERVICIO');
    final String? payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      print('Payload recibido: $payload -> Enviando al Stream de Clics');
      _notificationServices._notificationClickController.sink.add(payload);
    }
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const AndroidNotificationChannel agendaChannel = AndroidNotificationChannel(
      'canal_agenda-id',
      'Recordatorios de Agenda',
      importance: Importance.max,
      description: 'Canal para recordatorios de actividades programadas',
    );

    const AndroidNotificationChannel firebaseChannel =
        AndroidNotificationChannel(
          'high_importance_channel',
          'Notificaciones Generales',
          importance: Importance.max,
          description: 'Canal para notificaciones importantes y de marketing',
        );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(agendaChannel);
    await androidPlugin?.createNotificationChannel(firebaseChannel);
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationClicked,
    );
  }

  Future<void> requestPermisions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required DateTime scheduledDate,
  }) async {
    final tz.TZDateTime tzScheduleDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'canal_agenda-id',
          'Notificacion de agenda',
          importance: Importance.max,
          channelDescription: 'Canal para recordatorios de actividades',
          priority: Priority.high,
        );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduleDate,
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
    print('Notificación programada con .zonedSchedule() para $tzScheduleDate');
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'canal_agenda-id',
          'Notificacion de agenda',
          channelDescription: 'Canal para recordatorios de actividades',
          importance: Importance.max,
          priority: Priority.high,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: 'Desde WorkManager',
    );
  }

  Future<void> showFirebaseNotification(RemoteMessage message) async {
    final String? title = message.notification?.title;
    final String? body = message.notification?.body;
    final String? payload = message.data['Mensaje'];

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'Notificaciones Generales',
          importance: Importance.max,
          channelDescription:
              'Canal para notificaciones importantes y de marketing',
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

  void dispose() {
    _notificationClickController.close();
    _payloadDisplayController.close();
  }
}
