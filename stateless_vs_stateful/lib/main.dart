import 'package:flutter/material.dart';
import 'package:stateless_vs_stateful/screens/screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stateless vs Stateful'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        body: Screen(),
      ),
    );
  }
}
