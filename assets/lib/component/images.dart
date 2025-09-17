import 'package:flutter/material.dart';

class Images extends StatefulWidget {
  final int value;
  const Images({super.key, required this.value});

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  int get value => widget.value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
      child: Expanded(
        child: Container(
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset(
              'assets/images/$value.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'No more images',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
