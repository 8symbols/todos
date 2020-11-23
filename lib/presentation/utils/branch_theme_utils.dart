import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';

/// Функции для работы с темой ветки.
abstract class BranchThemeUtils {
  /// Создает тему на основе темы ветки [branchTheme].
  static ThemeData createTheme(BranchTheme branchTheme) =>
      ThemeData.light().copyWith(
        primaryColor: branchTheme.primaryColor,
        accentColor: branchTheme.primaryColor,
        toggleableActiveColor: branchTheme.primaryColor,
        scaffoldBackgroundColor: branchTheme.secondaryColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF01A39D),
          foregroundColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData.fallback().copyWith(color: Colors.white),
        ),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: branchTheme.primaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all<Color>(branchTheme.primaryColor),
          ),
        ),
        buttonColor: const Color(0xFF01A39D),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF01A39D),
        ),
      );
}
