import 'package:flutter/material.dart';

class CustomPaintScreen extends StatelessWidget {
  const CustomPaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localizations.localeOf(context).languageCode == "es"
              ? "Dibujo"
              : "Drawing",
        ),
      ),
      body: Center(
        child: CustomPaint(size: const Size(200, 200), painter: MyPainter()),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintCircle = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      100,
      paintCircle,
    );

    final paintRect = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final paintRect2 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final paintRect3 = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    final paintRect4 = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(50, 30, 100, 10), paintRect4);

    canvas.drawRect(Rect.fromLTWH(50, 50, 10, 90), paintRect);
    canvas.drawRect(Rect.fromLTWH(140, 50, 10, 90), paintRect2);

    canvas.drawRect(Rect.fromLTWH(50, 150, 100, 10), paintRect3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
