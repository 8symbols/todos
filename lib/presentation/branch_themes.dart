import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';

/// Класс для хранения тем веток.
abstract class BranchThemes {
  /// Тема ветки по умолчанию.
  static const defaultBranchTheme =
      BranchTheme(Color(0xFF6202EE), Color(0xFFB5C9FD));

  /// Доступные темы веток.
  static const branchThemes = [
    BranchTheme(Color(0xFFD50000), Color(0xFFEF9A9A)),
    BranchTheme(Color(0xFFEF6C00), Color(0xFFFFCC80)),
    BranchTheme(Color(0xFFFDD835), Color(0xFFFFF59D)),
    BranchTheme(Color(0xFF388E3C), Color(0xFFA5D6A7)),
    BranchTheme(Color(0xFF0288D1), Color(0xFF81D4FA)),
    defaultBranchTheme,
  ];
}
