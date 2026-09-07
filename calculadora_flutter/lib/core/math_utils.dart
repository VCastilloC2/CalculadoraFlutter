import 'dart:math' as math;

class MathUtils {
  // Verificar si es par
  static bool isEven(double num) => num % 2 == 0;

  // Verificar si es Fibonacci (Un número es Fibonacci si (5*n^2 + 4) o (5*n^2 - 4) es un cuadrado perfecto)
  static bool isFibonacci(double num) {
    if (num < 0 || num != num.toInt()) return false;
    int n = num.toInt();
    return _isPerfectSquare(5 * n * n + 4) || _isPerfectSquare(5 * n * n - 4);
  }

  // Determina si un número entero es un cuadrado perfecto
  static bool _isPerfectSquare(int x) {
    int s = math.sqrt(x).round();
    return s * s == x;
  }

  // Trigonometría (asumiendo que la entrada está en radianes, si quieres grados multiplica por pi/180)
  static double getSin(double num) => math.sin(num);
  static double getCos(double num) => math.cos(num);
  static double getTan(double num) => math.tan(num);

  // Operaciones Avanzadas
  static double logBase(double val, double base) => math.log(val) / math.log(base);
  static double root(double radicand, double index) => math.pow(radicand, 1 / index).toDouble();
}