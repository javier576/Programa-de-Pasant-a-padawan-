import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:CustomPaint/app_config.dart';
import 'screens/login_screen.dart';

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    Color appBarColor;

    if (config.flavor == Flavor.dev) {
      appBarColor = Colors.red;
    } else {
      appBarColor = Colors.green;
    }

    return MaterialApp(
      supportedLocales: const [Locale("en", ""), Locale("es", "")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: config.showDebugBanner,
      title: config.appTitle,

      home: Scaffold(
        appBar: AppBar(
          title: Text(config.appTitle),
          centerTitle: true,
          backgroundColor: appBarColor,
        ),

        body: const LoginScreen(),
      ),
    );
  }
}
