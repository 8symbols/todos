import 'package:todos/domain/models/todo_list_view_settings.dart';

/// Класс для хранения настроек пользователя.
abstract class ISettingsStorage {
  /// Сохраняет настройки отображения списка задач.
  Future<void> saveTodoListViewSettings(TodoListViewSettings settings);

  /// Загружает настройки отображения списка задач.
  Future<TodoListViewSettings> getTodoListViewSettings();
}
