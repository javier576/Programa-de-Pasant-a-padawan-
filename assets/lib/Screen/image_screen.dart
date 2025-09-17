import 'package:assets/Screen/new_screen.dart';
import 'package:assets/component/cambiarFoto.dart';
import 'package:flutter/material.dart';
import "package:assets/component/images.dart";

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  int selectedPhoto = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(selectedPhoto.toString()),
        Images(value: selectedPhoto),
        Container(
          child: Cambiarfoto(
            title: 'Cambiar Foto',
            value: selectedPhoto,
            onIncrement: () {
              setState(() {
                selectedPhoto++;
              });
            },
            onDecrement: () {
              setState(() {
                if (selectedPhoto > 1) {
                  selectedPhoto--;
                }
              });
            },
          ),
        ),

        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewScreen()),
                );
              },
              style: ButtonStyle(),
              child: Text(
                "Ir a la siguiente pagina",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
