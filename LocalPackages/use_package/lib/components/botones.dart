import 'package:flutter/material.dart';

class Botones extends StatelessWidget {
  final Text icon;
  final Color color;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const Botones({
    super.key,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: 96,
        height: 96,
        child: IconButton(
          onPressed: onPressed,
          icon: Text(
            icon.data!,
            style: TextStyle(
              color: color,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
          ),
        ),
      ),
    );
  }
}
