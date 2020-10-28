import 'package:flutter/material.dart' as m;
import 'package:meta/meta.dart';
import 'package:todos/data/repositories/todos_repository/models/theme.dart';
import 'package:todos/data/repositories/todos_repository/models/todo_priority.dart';
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

  final Theme theme;

  Todo({
    String id,
    bool isFavorite,
    bool wasCompleted,
    DateTime creationTime,
    TodoPriority priority,
    Theme theme,
    this.notes,
    this.deadlineTime,
    this.notificationTime,
    @required this.title,
  })  : id = id ?? Uuid().v4(),
        isFavorite = isFavorite ?? false,
        wasCompleted = wasCompleted ?? false,
        creationTime = creationTime ?? DateTime.now(),
        priority = priority ?? TodoPriority.medium,
        theme = theme ?? ColorTheme(m.Colors.amber),
        assert(title != null);

  Todo copyWith({
    String id,
    bool isFavorite,
    bool wasCompleted,
    DateTime creationTime,
    TodoPriority priority,
    Theme theme,
    String notes,
    DateTime deadlineTime,
    DateTime notificationTime,
    String title,
  }) {
    return Todo(
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      creationTime: creationTime ?? this.creationTime,
      priority: priority ?? this.priority,
      theme: theme ?? this.theme,
      notes: notes ?? this.notes,
      deadlineTime: deadlineTime ?? this.deadlineTime,
      notificationTime: notificationTime ?? this.notificationTime,
      title: title ?? this.title,
    );
  }
}
