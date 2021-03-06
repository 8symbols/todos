import 'dart:io';
import 'dart:math';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_screen_menu_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/utils/image_utils.dart';

/// AppBar на экране задачи.
class TodoSliverAppBar extends SliverPersistentHeaderDelegate {
  static const _fabSize = 56.0;

  static const _minExtent = 56.0;

  /// Задача.
  final Todo _todo;

  /// Высота в развернутом состоянии без учета полосы уведомлений.
  final double _maxExtent;

  /// Высота полосы уведомлений.
  ///
  /// Предполагается, что это значение "MediaQuery.of(context).padding.top".
  final double _unsafeAreaHeight;

  /// Есть ли фотография на заднем плане.
  bool get _hasBackgroundImage => _todo.mainImagePath != null;

  TodoSliverAppBar(this._maxExtent, this._unsafeAreaHeight, this._todo);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final imageProvider =
        _hasBackgroundImage ? FileImage(File(_todo.mainImagePath)) : null;

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: _fabSize / 2.0),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_hasBackgroundImage)
                  InkWell(
                    onDoubleTap: () => ImageUtils.openImageFullScreen(
                      context,
                      imageProvider,
                      _todo.mainImagePath,
                    ),
                    child: Hero(
                      tag: _todo.mainImagePath,
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: _unsafeAreaHeight),
                  child: _buildAppBarContent(context, shrinkOffset),
                ),
              ],
            ),
          ),
        ),
        _buildFab(context, shrinkOffset),
      ],
    );
  }

  Widget _buildFab(BuildContext context, double shrinkOffset) {
    return Positioned(
      width: _fabSize,
      height: _fabSize,
      left: 16.0,
      bottom: 0.0,
      child: Transform.scale(
        scale: _calculateFabScale(shrinkOffset),
        child: FloatingActionButton(
          onPressed: () =>
              _changeTodoWasCompleted(context, !_todo.wasCompleted),
          child: Icon(
            _todo.wasCompleted ? Icons.close : Icons.check,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarContent(BuildContext context, double shrinkOffset) {
    final currentExtent = max(minExtent, maxExtent - shrinkOffset);
    final backgroundColor =
        _hasBackgroundImage ? Theme.of(context).buttonColor : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildButtonWithBackground(
          _minExtent,
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor,
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: FlexibleSpaceBar.createSettings(
            currentExtent: currentExtent,
            maxExtent: maxExtent,
            minExtent: minExtent,
            child: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding:
                  const EdgeInsets.only(top: 4.0, bottom: 8.0, left: 4.0),
              title: _hasBackgroundImage
                  ? BorderedText(
                      strokeColor: backgroundColor,
                      strokeWidth: 4.0,
                      child: Text(
                        _todo.title,
                        overflow: TextOverflow.visible,
                      ),
                    )
                  : Text(_todo.title),
            ),
          ),
        ),
        _buildButtonWithBackground(
          48.0,
          IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: TodoScreenMenuOptions(_todo),
          ),
          backgroundColor,
        ),
      ],
    );
  }

  Widget _buildButtonWithBackground(
    double width,
    Widget button, [
    Color backgroundColor,
  ]) {
    return SizedBox(
      width: width,
      height: _minExtent,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: button,
      ),
    );
  }

  @override
  double get maxExtent => _maxExtent + _unsafeAreaHeight + _fabSize / 2.0;

  @override
  double get minExtent => _minExtent + _unsafeAreaHeight + _fabSize / 2.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  double _calculateFabScale(double shrinkOffset) {
    final pixelsFromMin = max(0, _maxExtent - shrinkOffset - _fabSize);
    return pixelsFromMin > _fabSize ? 1.0 : pixelsFromMin / _fabSize;
  }

  void _changeTodoWasCompleted(BuildContext context, bool wasCompleted) {
    context
        .read<TodoBloc>()
        .add(TodoEditedEvent(_todo.copyWith(wasCompleted: wasCompleted)));
  }
}
