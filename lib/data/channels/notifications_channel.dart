import 'package:flutter/services.dart';
import 'package:todos/domain/models/todo.dart';

/// Канал для работы с уведомлениями.
abstract class NotificationsChannel {
  static const platform = MethodChannel('todos/notifications');

  /// Вызывает нативный код для планирования уведомления.
  ///
  /// Вызывает метод "scheduleNotification".
  ///
  /// Передает id задачи "todo_id", название задачи "title" и время
  /// уведомления в миллисекундах "time_millis".
  static Future<bool> scheduleNotification(Todo todo) async {
    return await platform.invokeMethod('scheduleNotification', {
      "todo_id": todo.id,
      "title": todo.title,
      "time_millis": todo.notificationTime.millisecondsSinceEpoch,
    });
  }

  /// Вызывает нативный код для отмены уведомления.
  ///
  /// Вызывает метод "cancelNotification".
  ///
  /// Передает id задачи "todo_id", название задачи "title" и время
  /// уведомления в миллисекундах "time_millis".
  static Future<bool> cancelNotification(Todo todo) async {
    return await platform.invokeMethod('cancelNotification', {
      "todo_id": todo.id,
      "title": todo.title,
      "time_millis": todo.notificationTime.millisecondsSinceEpoch,
    });
  }
}
