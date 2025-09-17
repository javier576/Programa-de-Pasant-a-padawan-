import 'package:assets/main.dart';
import 'package:flutter/material.dart';
import "package:assets/component/images.dart";

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  int photo = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: newAppbar(), body: newBody());
  }

  Widget newBody() {
    return Column(
      children: [
        Spacer(),
        Text(
          "Nueva Pantalla",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Images(value: photo),
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
                  MaterialPageRoute(builder: (context) => MainApp()),
                );
              },
              style: ButtonStyle(),
              child: Text(
                "Regresar a la pagina anterior",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar newAppbar() {
    return AppBar(
      title: Text('New Screen'),
      backgroundColor: Colors.green,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
