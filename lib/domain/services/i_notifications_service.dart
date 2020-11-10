import 'package:todos/domain/models/todo.dart';

/// Интерфейс для работы с уведомлениями.
abstract class INotificationsService {
  /// Планирует уведомление с текстом [todo.title]
  /// во время [todo.notificationTime].
  ///
  /// Возвращает true в случае успешного выполнения.
  Future<bool> scheduleNotification(Todo todo);

  /// Отменяет уведомление с текстом [todo.title]
  /// во время [todo.notificationTime].
  ///
  /// Возвращает true в случае успешного выполнения.
  Future<bool> cancelNotification(Todo todo);
}
