import 'package:flutter/material.dart';
import 'package:paquetes/components/paquete.dart';

class Screan extends StatefulWidget {
  const Screan({super.key});

  @override
  State<Screan> createState() => _ScreanState();
}

class _ScreanState extends State<Screan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade200, Colors.blue.shade50],
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(height: 40),
          Paquete(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Flutter Swiper es una librería que permite crear carruseles de imágenes de manera sencilla y personalizable en aplicaciones Flutter.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 325),
        ],
      ),
    );
  }
}
