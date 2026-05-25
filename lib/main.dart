import 'package:flutter/material.dart';
import 'package:prova/screens/splash.dart';

void main() {// função principal
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen()
    );
  }
}

