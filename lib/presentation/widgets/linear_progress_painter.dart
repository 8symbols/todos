import 'package:flutter/material.dart';

/// Полоса загрузки.
class LinearProgressPainter extends CustomPainter {
  /// Прогресс выполнения.
  ///
  /// Может принимать значения из диапазона [0, 1].
  final double progress;

  final Paint _strokePaint;

  final Paint _backgroundPaint;

  final Paint _progressPaint;

  /// Создает полосу с цветом загруженной части [color] и цветом незагруженной
  /// части [backgroundColor].
  LinearProgressPainter(
    this.progress,
    Color color, {
    Color backgroundColor = Colors.white,
  })  : _strokePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
        _backgroundPaint = Paint()..color = backgroundColor,
        _progressPaint = Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height);

    final backgroundRRect =
        RRect.fromLTRBR(0.0, 0.0, size.width, size.height, radius);
    final progressRRect =
        RRect.fromLTRBR(0.0, 0.0, size.width * progress, size.height, radius);

    canvas.drawRRect(backgroundRRect, _backgroundPaint);
    canvas.drawRRect(progressRRect, _progressPaint);
    canvas.drawRRect(backgroundRRect, _strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
