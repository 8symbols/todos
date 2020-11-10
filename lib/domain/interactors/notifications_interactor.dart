import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

/// Интерактор для установки напоминаний.
class NotificationsInteractor {
  final INotificationsService _notificationsService;

  NotificationsInteractor(this._notificationsService);

  /// Планирует уведомление с текстом [todo.title]
  /// во время [todo.notificationTime].
  ///
  /// Возвращает true в случае успешного выполнения.
  Future<bool> scheduleNotification(Todo todo) async {
    return _notificationsService.scheduleNotification(todo);
  }

  /// Отменяет уведомление с текстом [todo.title]
  /// во время [todo.notificationTime].
  ///
  /// Возвращает true в случае успешного выполнения.
  Future<bool> cancelNotification(Todo todo) async {
    return _notificationsService.cancelNotification(todo);
  }
}
