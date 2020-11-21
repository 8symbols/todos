import 'dart:math';

import 'package:flutter/material.dart';

/// Круговая полоса загрузки.
class RadialProgressPainter extends CustomPainter {
  /// Прогресс выполнения.
  ///
  /// Может принимать значения из диапазона [0, 1].
  final double progress;

  final Paint _backgroundPaint;

  final Paint _progressPaint;

  /// Создает полосу с цветом загруженной части [color] и цветом незагруженной
  /// части [backgroundColor].
  RadialProgressPainter(
    this.progress,
    Color color, {
    Color backgroundColor = const Color(0xFFC4C4C4),
  })  : _backgroundPaint = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0,
        _progressPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    final progressAngle = 2.0 * pi * progress;
    final startAngle = -pi / 2.0 - progressAngle;

    canvas.drawArc(rect, 0.0, 2.0 * pi, false, _backgroundPaint);
    canvas.drawArc(rect, startAngle, progressAngle, false, _progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
