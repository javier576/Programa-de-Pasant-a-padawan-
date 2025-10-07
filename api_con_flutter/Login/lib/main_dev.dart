import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'app_config.dart';

void main() {
  AppConfig(
    flavor: Flavor.dev,
    appTitle: "Formulario (Dev)",
    showDebugBanner: true,
  );

  runApp(const MyAppWrapper());
}
