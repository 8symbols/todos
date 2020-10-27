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
}
