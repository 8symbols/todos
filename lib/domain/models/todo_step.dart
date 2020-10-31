import 'package:uuid/uuid.dart';

/// Модель пункта задачи.
class TodoStep {
  /// Уникальный идентификатор пункта.
  final String id;

  /// Флаг, сигнализирующий о том, является ли пункт выполненным.
  final bool wasCompleted;

  /// Содержание пункта.
  final String title;

  /// Создает пункт.
  ///
  /// Если не указан [id], то генерируется новый идентификатор.
  TodoStep(
    this.title, {
    String id,
    this.wasCompleted = false,
  })  : id = id ?? Uuid().v4(),
        assert(title != null),
        assert(wasCompleted != null);

  TodoStep copyWith({String id, bool wasCompleted, String title}) {
    return TodoStep(
      title ?? this.title,
      id: id ?? this.id,
      wasCompleted: wasCompleted ?? this.wasCompleted,
    );
  }
}
