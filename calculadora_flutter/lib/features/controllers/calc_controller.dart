import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../enums/CalcOp.dart';
import '../../../../core/math_utils.dart';

class CalcController extends ChangeNotifier {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();

  double? num1;
  double? num2;
  String resultText = "0";
  String labelResult = "Resultado";

  void updateNumbers() {
    num1 = double.tryParse(num1Controller.text);
    num2 = double.tryParse(num2Controller.text);
    notifyListeners();
  }

  void calculate(CalcOp operation) {
    if (num1 == null || num2 == null) {
      resultText = "Error: Ingrese 2 números";
      notifyListeners();
      return;
    }

    double n1 = num1!;
    double n2 = num2!;

    switch (operation) {
      case CalcOp.add:
        resultText = (n1 + n2).toStringAsFixed(2);
        labelResult = "Suma";
        break;
      case CalcOp.subtract:
        resultText = (n1 - n2).toStringAsFixed(2);
        labelResult = "Resta";
        break;
      case CalcOp.multiply:
        resultText = (n1 * n2).toStringAsFixed(2);
        labelResult = "Producto";
        break;
      case CalcOp.divide:
        resultText = n2 == 0 ? "Indefinido (div por 0)" : (n1 / n2).toStringAsFixed(4);
        labelResult = "Cociente";
        break;
      case CalcOp.power:
        resultText = math.pow(n1, n2).toStringAsFixed(4);
        labelResult = "Potencia ($n1 ^ $n2)";
        break;
      case CalcOp.root:
        resultText = n2 == 0 ? "Error" : MathUtils.root(n1, n2).toStringAsFixed(4);
        labelResult = "Raíz (Radicando: $n1, Índice: $n2)";
        break;
      case CalcOp.log:
        resultText = MathUtils.logBase(n1, n2).toStringAsFixed(4);
        labelResult = "Logaritmo (Base $n2 de $n1)";
        break;
    }
    notifyListeners();
  }
}