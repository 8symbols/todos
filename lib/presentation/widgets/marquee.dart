import 'package:flutter/material.dart';

/// Виджет, который автоматически прокручивает своего [child] в цикле.
class Marquee extends StatefulWidget {
  /// Виджет, который будет прокручиваться.
  final Widget child;

  /// Ось прокрутки.
  final Axis direction;

  /// Длительность прокрутки.
  final Duration scrollingDuration;

  /// Ожидание между прокрутками.
  final Duration pauseDuration;

  Marquee({
    @required this.child,
    this.direction = Axis.horizontal,
    this.scrollingDuration = const Duration(milliseconds: 4000),
    this.pauseDuration = const Duration(milliseconds: 2000),
  });

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    scroll();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: _scrollController,
    );
  }

  Future<void> scroll() async {
    while (true) {
      if (_scrollController.hasClients) {
        await Future.delayed(widget.pauseDuration);
        if (_scrollController.hasClients) {
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: widget.scrollingDuration,
            curve: Curves.easeIn,
          );
        }
        await Future.delayed(widget.pauseDuration);
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      } else {
        await Future.delayed(widget.pauseDuration);
      }
    }
  }
}
