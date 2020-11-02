import 'package:flutter/material.dart';

/// Тема ветки задач.
class BranchTheme {
  /// Цвет, который ставится в [AppBar.backgroundColor].
  final Color primaryColor;

  /// Цвет, который ставится в [Scaffold.backgroundColor].
  final Color secondaryColor;

  const BranchTheme(this.primaryColor, this.secondaryColor)
      : assert(primaryColor != null),
        assert(secondaryColor != null);
}
