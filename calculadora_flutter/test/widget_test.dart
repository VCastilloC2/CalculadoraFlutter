import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_flutter/main.dart';

void main() {
  testWidgets('Calculadora Premium smoke test - Verifica carga de inputs y título', (WidgetTester tester) async {
    // 1. Construimos nuestra app y disparamos el primer frame.
    await tester.pumpWidget(const PremiumCalculatorApp());

    // 2. Verificamos que el AppBar muestra el título correcto de la calculadora.
    expect(find.text('Calculadora Científica'), findsOneWidget);

    // 3. Verificamos que los dos inputs principales ("Número 1" y "Número 2") están presentes en la pantalla.
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Número 1'), findsOneWidget);
    expect(find.text('Número 2'), findsOneWidget);

    // 4. Verificamos que los botones de operaciones principales estén renderizados.
    expect(find.text('+'), findsOneWidget);
    expect(find.text('-'), findsOneWidget);
    expect(find.text('×'), findsOneWidget);
    expect(find.text('÷'), findsOneWidget);
  });
}