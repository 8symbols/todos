import 'package:flutter/material.dart';
import 'package:todos/presentation/branch_themes.dart';

/// Тема приложения.
final theme = ThemeData(
  primaryColor: BranchThemes.defaultBranchTheme.primaryColor,
  scaffoldBackgroundColor: BranchThemes.defaultBranchTheme.primaryColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF01A39D),
  ),
);
