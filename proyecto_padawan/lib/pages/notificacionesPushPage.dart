import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_padawan/src/providers/push_notification_provider.dart';

class Notificacionespushpage extends StatefulWidget {
  final Stream<String> mensajeNotificacion;
  const Notificacionespushpage({super.key, required this.mensajeNotificacion});

  @override
  State<Notificacionespushpage> createState() => _NotificacionespushpageState();
}

class _NotificacionespushpageState extends State<Notificacionespushpage> {
  String mensaje = 'Esperando Notificacion';
  late StreamSubscription<String> streamSubscription;
  @override
  void initState() {
    super.initState();

    streamSubscription = widget.mensajeNotificacion.listen((mensajeRecibido) {
      if (mounted) {
        setState(() {
          mensaje = mensajeRecibido;
        });
      }
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
