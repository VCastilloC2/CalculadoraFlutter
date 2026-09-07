import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedCalcButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const AnimatedCalcButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  State<AnimatedCalcButton> createState() => _AnimatedCalcButtonState();
}

class _AnimatedCalcButtonState extends State<AnimatedCalcButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    // Sonido nativo de clic y vibración sutil al tocar
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedScale es una forma muy limpia de hacer animaciones de tamaño en Flutter
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0, // Se reduce al 90% de su tamaño al presionar
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: widget.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? [] // Sin sombra cuando está presionado (efecto hundido)
                : [
              BoxShadow(
                color: widget.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}