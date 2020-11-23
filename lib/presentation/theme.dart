import 'package:flutter/material.dart';
import 'package:todos/presentation/constants/branch_themes.dart';

/// Тема приложения.
final theme = ThemeData(
  primaryColor: BranchThemes.defaultBranchTheme.primaryColor,
  accentColor: BranchThemes.defaultBranchTheme.primaryColor,
  scaffoldBackgroundColor: BranchThemes.defaultBranchTheme.secondaryColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF01A39D),
  ),
);
