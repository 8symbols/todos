import 'package:flutter/material.dart';
import 'package:todos/presentation/widgets/radial_progress_painter.dart';

/// Анимированная круговая полоса прогресса.
class TweenRadialProgress extends StatelessWidget {
  /// Прогресс.
  ///
  /// Должен быть значением из диапазона [0, 1].
  final double progress;

  /// Цвет загруженной части.
  final Color color;

  /// Размер круга.
  final double size;

  /// Размер шрифта.
  final double fontSize;

  const TweenRadialProgress(
    this.progress,
    this.color, {
    this.size = 52.0,
    this.fontSize = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: progress),
      builder: (context, value, child) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          child: child,
          painter: RadialProgressPainter(value, color),
        ),
      ),
      child: Center(
        child: Text(
          '${(progress * 100.0).round()}%',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
