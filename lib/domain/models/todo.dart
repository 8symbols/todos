import 'package:todos/domain/models/todo_priority.dart';
import 'package:todos/domain/models/todo_theme.dart';
import 'package:uuid/uuid.dart';

class Todo {
  final String id;

  final bool isFavorite;

  final bool wasCompleted;

  final String title;

  final String notes;

  final DateTime deadlineTime;

  final DateTime notificationTime;

  final DateTime creationTime;

  final TodoPriority priority;

  final TodoTheme theme;

  Todo(
    this.title, {
    String id,
    this.isFavorite = false,
    this.wasCompleted = false,
    DateTime creationTime,
    this.priority = TodoPriority.medium,
    this.theme,
    this.notes,
    this.deadlineTime,
    this.notificationTime,
  })  : id = id ?? Uuid().v4(),
        creationTime = creationTime ?? DateTime.now(),
        assert(title != null),
        assert(isFavorite != null),
        assert(wasCompleted != null),
        assert(priority != null);

  Todo copyWith({
    String id,
    bool isFavorite,
    bool wasCompleted,
    DateTime creationTime,
    TodoPriority priority,
    TodoTheme theme,
    String notes,
    DateTime deadlineTime,
    DateTime notificationTime,
    String title,
  }) {
    return Todo(
      title ?? this.title,
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      creationTime: creationTime ?? this.creationTime,
      priority: priority ?? this.priority,
      theme: theme ?? this.theme,
      notes: notes ?? this.notes,
      deadlineTime: deadlineTime ?? this.deadlineTime,
      notificationTime: notificationTime ?? this.notificationTime,
    );
  }
}
