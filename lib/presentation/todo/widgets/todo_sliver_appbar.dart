import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/todo/widgets/todo_screen_menu_options.dart';

/// AppBar на экране задачи.
class TodoSliverAppBar extends StatelessWidget {
  /// Тема ветки.
  final BranchTheme _branchTheme;

  /// Задача.
  final Todo _todo;

  /// Высота в развернутом состоянии.
  final double _expandedHeight;

  TodoSliverAppBar(this._expandedHeight, this._branchTheme, this._todo);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: _branchTheme.primaryColor,
      expandedHeight: _expandedHeight,
      pinned: true,
      actions: [TodoScreenMenuOptions(_todo)],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            const EdgeInsets.only(left: 72.0, right: 40.0, bottom: 16.0),
        title: SafeArea(child: Text(_todo.title)),
        background: _todo.themeImagePath != null
            ? Image.file(File(_todo.themeImagePath), fit: BoxFit.cover)
            : null,
      ),
    );
  }
}
