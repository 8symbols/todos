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
  Branch(
    this.title,
    this.theme, {
    String id,
  })  : id = id ?? Uuid().v4(),
        assert(title != null),
        assert(theme != null);

  Branch copyWith({String id, BranchTheme theme, String title}) {
    return Branch(
      title ?? this.title,
      theme ?? this.theme,
      id: id ?? this.id,
    );
  }
}
