import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  initNotification() {
    firebaseMessaging.requestPermission();
    firebaseMessaging.getToken().then((token) {
      print('===== FCM Token =====');
      print(token);
    });
  }
}
