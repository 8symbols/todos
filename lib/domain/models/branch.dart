import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:uuid/uuid.dart';

/// Модель ветки задач.
class Branch {
  /// Уникальный идентификатор ветки.
  final String id;

  /// Название ветки.
  final String title;

  /// Тема ветки.
  final BranchTheme theme;

  /// Создает ветку.
  ///
  /// Если не указан [id], то генерируется новый идентификатор.
  /// Если не указана тема [theme], то используется стандартная.
  Branch(
    this.title, {
    String id,
    this.theme = const BranchTheme(Color(0xFF6202EE), Color(0xFFB5C9FD)),
  })  : id = id ?? Uuid().v4(),
        assert(title != null),
        assert(theme != null);

  Branch copyWith({String id, BranchTheme theme, String title}) {
    return Branch(
      title ?? this.title,
      id: id ?? this.id,
      theme: theme ?? this.theme,
    );
  }
}
