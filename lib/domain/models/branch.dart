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

  /// Время создания ветки.
  final DateTime creationTime;

  /// Время последнего использования ветки.
  final DateTime lastUsageTime;

  /// Создает ветку.
  ///
  /// Если не указан [id], то генерируется новый идентификатор.
  /// Если не указано время использования [lastUsageTime], используется
  /// текущее время. Если не указано время создания [creationTime],
  /// используется текущее время.
  Branch(
    this.title,
    this.theme, {
    String id,
    DateTime lastUsageTime,
    DateTime creationTime,
  })  : id = id ?? Uuid().v4(),
        lastUsageTime = lastUsageTime ?? DateTime.now(),
        creationTime = creationTime ?? DateTime.now(),
        assert(title != null),
        assert(theme != null);

  Branch copyWith({
    String id,
    BranchTheme theme,
    String title,
    DateTime lastUsageTime,
    DateTime creationTime,
  }) {
    return Branch(
      title ?? this.title,
      theme ?? this.theme,
      id: id ?? this.id,
      lastUsageTime: lastUsageTime ?? this.lastUsageTime,
      creationTime: creationTime ?? this.creationTime,
    );
  }
}
