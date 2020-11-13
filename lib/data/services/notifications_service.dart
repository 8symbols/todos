import 'package:todos/data/channels/notifications_channel.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

/// Сервис для работы с уведомлениями.
class NotificationsService implements INotificationsService {
  @override
  Future<bool> scheduleNotification(Todo todo) async {
    return NotificationsChannel.scheduleNotification(todo);
  }

  @override
  Future<bool> cancelNotification(Todo todo) async {
    return NotificationsChannel.cancelNotification(todo);
  }
}
