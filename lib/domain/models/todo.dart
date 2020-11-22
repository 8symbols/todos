import 'package:flutter/material.dart';
import 'package:todos/domain/wrappers/nullable.dart';
import 'package:uuid/uuid.dart';

/// Модель задачи.
class Todo {
  /// Уникальный идентификатор задачи.
  final String id;

  /// Флаг, сигнализирующий о том, является ли задача избранной.
  final bool isFavorite;

  /// Флаг, сигнализирующий о том, является ли задача выполненной.
  final bool wasCompleted;

  /// Название задачи.
  final String title;

  /// Комментарии к задаче.
  ///
  /// Может быть равным null.
  final String note;

  /// Дедлайн задачи.
  ///
  /// Может быть равным null.
  final DateTime deadlineTime;

  /// Время напоминания о задаче.
  ///
  /// Может быть равным null.
  final DateTime notificationTime;

  /// Время создания задачи.
  final DateTime creationTime;

  /// Путь к фотографии, которая устанавливается в [AppBar] на экране задачи.
  ///
  /// Может быть равным null. В этом случае [AppBar] окрашивается в цвет ветки
  /// [Branch], которой принадлежит задача.
  final String themeImagePath;

  /// Создает задачу.
  ///
  /// Если не указан [id], то генерируется новый идентификатор.
  /// Если не указано время создания [creationTime], то используется текущее.
  Todo(
    this.title, {
    String id,
    DateTime creationTime,
    this.isFavorite = false,
    this.wasCompleted = false,
    this.themeImagePath,
    this.note,
    this.deadlineTime,
    this.notificationTime,
  })  : id = id ?? Uuid().v4(),
        creationTime = creationTime ?? DateTime.now(),
        assert(title != null),
        assert(isFavorite != null),
        assert(wasCompleted != null);

  Todo copyWith({
    String id,
    bool isFavorite,
    bool wasCompleted,
    DateTime creationTime,
    Nullable<String> themeImagePath,
    Nullable<String> note,
    Nullable<DateTime> deadlineTime,
    Nullable<DateTime> notificationTime,
    String title,
  }) {
    return Todo(
      title ?? this.title,
      id: id ?? this.id,
      isFavorite: isFavorite ?? this.isFavorite,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      creationTime: creationTime ?? this.creationTime,
      themeImagePath:
          themeImagePath != null ? themeImagePath.value : this.themeImagePath,
      note: note != null ? note.value : this.note,
      deadlineTime:
          deadlineTime != null ? deadlineTime.value : this.deadlineTime,
      notificationTime: notificationTime != null
          ? notificationTime.value
          : this.notificationTime,
    );
  }
}
