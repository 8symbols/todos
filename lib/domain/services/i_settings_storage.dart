import 'package:todos/domain/models/todo_list_view_settings.dart';

/// Класс для хранения настроек пользователя.
abstract class ISettingsStorage {
  /// Сохраняет настройки отображения списка задач.
  Future<void> saveTodoListViewSettings(TodoListViewSettings settings);

  /// Загружает настройки отображения списка задач.
  Future<TodoListViewSettings> getTodoListViewSettings();

  /// Сохраняет последний поисковый запрос во Flickr.
  Future<void> saveLastFlickrQuery(String query);

  /// Загружает последний поисковый запрос во Flickr.
  Future<String> getLastFlickrQuery();
}
