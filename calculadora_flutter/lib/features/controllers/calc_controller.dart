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

  // NUEVO: Variable para guardar los detalles adicionales de la operación
  String? operationDetails;

  void updateNumbers() {
    num1 = double.tryParse(num1Controller.text);
    num2 = double.tryParse(num2Controller.text);
    notifyListeners();
  }

  void calculate(CalcOp operation) {
    if (num1 == null || num2 == null) {
      resultText = "Error";
      operationDetails = "Ingrese ambos números";
      notifyListeners();
      return;
    }

    double n1 = num1!;
    double n2 = num2!;

    // Limpiamos los detalles antes de cada cálculo
    operationDetails = null;

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
        labelResult = "Cociente";
        if (n2 == 0) {
          resultText = "Indefinido";
          operationDetails = "La división por cero no es posible.";
        } else {
          resultText = (n1 / n2).toStringAsFixed(4);

          // Lógica de División Detallada
          double remainder = n1 % n2;
          bool isExact = remainder == 0;

          // Formateamos el resto para no mostrar ".00" si es exacto
          String remainderStr = isExact ? "0" : remainder.toStringAsFixed(2);
          String exactText = isExact ? "(la división es exacta)" : "(división inexacta)";

          operationDetails = "Dividendo: $n1\nDivisor: $n2\nResto: $remainderStr $exactText";
        }
        break;
      case CalcOp.power:
        resultText = math.pow(n1, n2).toStringAsFixed(4);
        labelResult = "Potencia";
        operationDetails = "Base: $n1 | Exponente: $n2";
        break;
      case CalcOp.root:
        labelResult = "Raíz";
        if (n2 == 0) {
          resultText = "Error";
          operationDetails = "El índice de la raíz no puede ser cero.";
        } else {
          resultText = MathUtils.root(n1, n2).toStringAsFixed(4);
          operationDetails = "Radicando: $n1 | Índice: $n2";
        }
        break;
      case CalcOp.log:
        resultText = MathUtils.logBase(n1, n2).toStringAsFixed(4);
        labelResult = "Logaritmo";
        operationDetails = "Base: $n2 | Argumento: $n1";
        break;
    }
    notifyListeners();
  }
}