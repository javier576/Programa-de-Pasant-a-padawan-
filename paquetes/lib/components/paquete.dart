import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class Paquete extends StatefulWidget {
  const Paquete({super.key});

  @override
  State<Paquete> createState() => _PaqueteState();
}

class _PaqueteState extends State<Paquete> {
  final List<String> images = [
    "https://picsum.photos/400/300?1",
    "https://picsum.photos/400/300?2",
    "https://picsum.photos/400/300?3",
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return Image.network(images[index], fit: BoxFit.cover);
          },
          itemCount: images.length,
          pagination: SwiperPagination(),
          control: SwiperControl(),
        ),
      ),
    );
  }
}
