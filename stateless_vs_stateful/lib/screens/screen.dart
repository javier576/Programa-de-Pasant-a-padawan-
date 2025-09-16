import 'package:flutter/material.dart';
import 'package:stateless_vs_stateful/components/statefull.dart';
import 'package:stateless_vs_stateful/components/stateless.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 140, 255)),
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [Statefull(), Stateless()]),
    );
    ;
  }
}
