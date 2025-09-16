import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';

class Statefull extends StatefulWidget {
  const Statefull({super.key});

  @override
  State<Statefull> createState() => _StatefullState();
}

class _StatefullState extends State<Statefull> {
  double cronometro = 0;
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 64, 221, 248),
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Statefull", style: TextStyle(fontSize: 24)),
              Text(
                cronometro.toStringAsFixed(2),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: iniciarCronometro,
                    child: Text("Iniciar"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: detenerCronometro,
                    child: Text("Detener"),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: reiniciarCronometro,
                    child: Text("Reiniciar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void iniciarCronometro() {
    timer?.cancel();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        cronometro += 0.01;
      });
    });
  }

  void detenerCronometro() {
    timer?.cancel();
  }

  void reiniciarCronometro() {
    setState(() {
      cronometro = 0;
    });
  }
}
