import 'package:flutter/material.dart';

class Stateless extends StatelessWidget {
  const Stateless({super.key});

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
          height: 100,
          width: double.infinity,
          child: Column(
            children: [
              Text("Stateless", style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(34.0),
                child: Text(
                  "Un StatelessWidget en Flutter es un tipo de widget inmutable, es decir, no cambia su contenido ni su apariencia después de ser construido. Su función es representar una parte de la interfaz de usuario que solo depende de los datos que recibe al crearse y no mantiene estado interno.",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
