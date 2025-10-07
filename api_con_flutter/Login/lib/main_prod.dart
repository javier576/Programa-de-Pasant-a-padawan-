import 'package:flutter/material.dart';
import 'app_widget.dart';
import 'app_config.dart';

void main() {
  AppConfig(
    flavor: Flavor.prod,
    appTitle: "Formulario",
    showDebugBanner: false,
  );

  runApp(const MyAppWrapper());
}
