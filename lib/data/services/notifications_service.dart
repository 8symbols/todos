import 'package:flutter/services.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

/// Класс для вызова нативного кода по работе с уведомлениями.
class NotificationsService extends INotificationsService {
  static const platform = MethodChannel('todos/notifications');

  /// Вызывает нативный код для планирования уведомления.
  ///
  /// Вызывает метод "scheduleNotification".
  ///
  /// Передает id задачи "todo_id", название задачи "title" и время
  /// уведомления в миллисекундах "time_millis".
  @override
  Future<bool> scheduleNotification(Todo todo) async {
    const method = 'scheduleNotification';
    return await platform.invokeMethod(method, {
      "todo_id": todo.id,
      "title": todo.title,
      "time_millis": todo.notificationTime.millisecondsSinceEpoch,
    });
  }

  /// Вызывает нативный код для отмены уведомления.
  ///
  /// Вызывает метод "cancelNotification".
  ///
  /// Передает id задачи "todo_id" и название задачи "title".
  @override
  Future<bool> cancelNotification(Todo todo) async {
    const method = 'cancelNotification';
    return await platform.invokeMethod(method, {
      "todo_id": todo.id,
      "title": todo.title,
    });
  }
}
