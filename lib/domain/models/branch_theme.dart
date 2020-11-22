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

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        runtimeType == other.runtimeType &&
            other is BranchTheme &&
            primaryColor == other.primaryColor &&
            secondaryColor == other.secondaryColor;
  }

  @override
  int get hashCode => primaryColor.hashCode ^ secondaryColor.hashCode;
}
