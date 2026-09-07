import 'package:flutter/material.dart';
import '../controllers/calc_controller.dart';
import '../enums/CalcOp.dart';
import '../widgets/premium_input.dart';
import '../../../../core/math_utils.dart';
import '../widgets/animated_calc_button.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalcController _controller = CalcController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Calculadora Científica', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- SECCIÓN DE INPUTS ---
                  Row(
                    children: [
                      Expanded(
                        child: PremiumInput(
                          label: 'Número 1',
                          controller: _controller.num1Controller,
                          onChanged: (v) => _controller.updateNumbers(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PremiumInput(
                          label: 'Número 2',
                          controller: _controller.num2Controller,
                          onChanged: (v) => _controller.updateNumbers(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- SECCIÓN DE RESULTADO PRINCIPAL ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(
                            _controller.labelResult,
                            style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 16)
                        ),
                        const SizedBox(height: 8),

                        // NUEVO: AnimatedSwitcher para el resultado
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            // Combina Fade y Scale para un efecto suave al cambiar el número
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(scale: animation, child: child),
                            );
                          },
                          child: Text(
                            _controller.resultText,
                            // La KEY es obligatoria para que AnimatedSwitcher sepa que el texto cambió
                            key: ValueKey<String>(_controller.resultText),
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        if (_controller.operationDetails != null) ...[
                          const SizedBox(height: 16),
                          Divider(
                            color: colorScheme.onPrimaryContainer.withOpacity(0.2),
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),

                          // NUEVO: También animamos los detalles matemáticos
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              _controller.operationDetails!,
                              key: ValueKey<String>(_controller.operationDetails!),
                              style: TextStyle(
                                color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                                fontSize: 16,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- BOTONES DE OPERACIONES ---
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildOpBtn('+', CalcOp.add, colorScheme),
                      _buildOpBtn('-', CalcOp.subtract, colorScheme),
                      _buildOpBtn('×', CalcOp.multiply, colorScheme),
                      _buildOpBtn('÷', CalcOp.divide, colorScheme),
                      _buildOpBtn('xⁿ', CalcOp.power, colorScheme),
                      _buildOpBtn('ⁿ√x', CalcOp.root, colorScheme),
                      _buildOpBtn('log', CalcOp.log, colorScheme),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- ANÁLISIS DE NÚMEROS (Características y Trig) ---
                  if (_controller.num1 != null || _controller.num2 != null)
                    _buildAnalysisPanel(colorScheme),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _buildOpBtn(String text, CalcOp op, ColorScheme colorScheme) {
    return AnimatedCalcButton(
      text: text,
      colorScheme: colorScheme,
      onPressed: () {
        _controller.calculate(op);
        HapticFeedback.mediumImpact();
      },
    );
  }

  Widget _buildAnalysisPanel(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Análisis de los Números', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            if (_controller.num1 != null) _buildNumberStats('Número 1', _controller.num1!),
            const SizedBox(height: 16),
            if (_controller.num2 != null) _buildNumberStats('Número 2', _controller.num2!),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberStats(String title, double num) {
    bool isEv = MathUtils.isEven(num);
    bool isFibo = MathUtils.isFibonacci(num);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title ($num):', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('• Paridad: ${isEv ? "Par" : "Impar"}'),
        Text('• Fibonacci: ${isFibo ? "Sí" : "No"}'),
        Text('• Seno: ${MathUtils.getSin(num).toStringAsFixed(4)}'),
        Text('• Coseno: ${MathUtils.getCos(num).toStringAsFixed(4)}'),
        Text('• Tangente: ${MathUtils.getTan(num).toStringAsFixed(4)}'),
      ],
    );
  }
}