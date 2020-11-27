import 'dart:math';

import 'package:flutter/material.dart';

/// Виджет, который делает [child] дрожащим.
class TremblingItem extends StatefulWidget {
  /// Угол отклонения.
  final double angle;

  /// Виджет, который нужно сделать дрожащим.
  final Widget child;

  /// Длительность анимации.
  final Duration duration;

  const TremblingItem({
    @required this.child,
    this.angle = 0.16 * pi / 180.0,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  _TremblingItemState createState() => _TremblingItemState();
}

class _TremblingItemState extends State<TremblingItem>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -widget.angle, end: widget.angle)
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}
