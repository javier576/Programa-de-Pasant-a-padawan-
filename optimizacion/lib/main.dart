import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Optimizada',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LargeListScreen(),
    );
  }
}

class LargeListScreen extends StatelessWidget {
  const LargeListScreen({super.key});

  int getExpensiveCalculation() {
    return List.generate(1000, (i) => i * 2).reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final items = List.generate(10000, (index) => 'Elemento $index');
    final expensiveCalculation = getExpensiveCalculation();

    return Scaffold(
      appBar: AppBar(title: const Text("Lista Optimizada")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            color: Colors.primaries[item.hashCode % Colors.primaries.length],
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      "https://picsum.photos/id/${item.hashCode % 200}/200/200",
                  width: 100,
                  height: 100,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  item,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Cálculo costoso precalculado: $expensiveCalculation"),
                ElevatedButton(
                  onPressed: () => debugPrint("Presionado $item"),
                  child: Text("Acción $item"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
