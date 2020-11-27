import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

/// Cubit для управления темой приложения.
class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit(ThemeData theme) : super(theme);

  /// Устанавливает тему [theme].
  void setTheme(ThemeData theme) => emit(theme);
}
