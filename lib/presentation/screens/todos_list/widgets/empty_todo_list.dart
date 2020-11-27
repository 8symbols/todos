import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todos/presentation/constants/assets_paths.dart';

/// Виджет для отображения пустого списка задач.
class EmptyTodoList extends StatefulWidget {
  @override
  _EmptyTodoListState createState() => _EmptyTodoListState();
}

class _EmptyTodoListState extends State<EmptyTodoList>
    with SingleTickerProviderStateMixin {
  static const _imageSideSize = 200.0;

  AnimationController _controller;

  Animation<RelativeRect> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    final begin = RelativeRect.fromSize(
      Rect.fromLTWH(0, _imageSideSize, _imageSideSize, _imageSideSize),
      const Size(_imageSideSize, _imageSideSize),
    );
    final end = RelativeRect.fromSize(
      Rect.fromLTWH(0, 0, _imageSideSize, _imageSideSize),
      const Size(_imageSideSize, _imageSideSize),
    );

    _animation = RelativeRectTween(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(_imageSideSize / 2.0);
    const borderRadius = BorderRadius.only(
      bottomLeft: radius,
      bottomRight: radius,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                SvgPicture.asset(
                  AssetsPaths.todoListBackground,
                  width: _imageSideSize,
                  height: _imageSideSize,
                ),
                PositionedTransition(
                  rect: _animation,
                  child: SvgPicture.asset(
                    AssetsPaths.todoList,
                    width: _imageSideSize,
                    height: _imageSideSize,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150.0),
            child: const Text(
              'На данный момент задачи отсутствуют',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
