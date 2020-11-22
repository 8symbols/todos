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

  /// Время последнего использования ветки.
  final DateTime lastUsageTime;

  /// Создает ветку.
  ///
  /// Если не указан [id], то генерируется новый идентификатор.
  /// Если не указано время использования [lastUsageTime], то используется
  /// текущее время.
  Branch(
    this.title,
    this.theme, {
    String id,
    DateTime lastUsageTime,
  })  : id = id ?? Uuid().v4(),
        lastUsageTime = lastUsageTime ?? DateTime.now(),
        assert(title != null),
        assert(theme != null);

  Branch copyWith(
      {String id, BranchTheme theme, String title, DateTime lastUsageTime}) {
    return Branch(
      title ?? this.title,
      theme ?? this.theme,
      id: id ?? this.id,
      lastUsageTime: lastUsageTime ?? this.lastUsageTime,
    );
  }
}
