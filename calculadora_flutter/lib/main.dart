import 'package:flutter/material.dart';
import 'features/pages/calculator_page.dart';

void main() {
  runApp(const PremiumCalculatorApp());
}

class PremiumCalculatorApp extends StatelessWidget {
  const PremiumCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Premium',
      theme: ThemeData(
        // Forzamos Material 3 y usamos un color base verde para generar una paleta armónica
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        fontFamily: 'Roboto', // Fuente limpia de Google
      ),
      home: const CalculatorPage(),
    );
  }
}