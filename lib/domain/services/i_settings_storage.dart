import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';

/// Класс для хранения настроек пользователя.
abstract class ISettingsStorage {
  /// Сохраняет настройки отображения списка задач.
  Future<void> saveTodosViewSettings(TodosViewSettings settings);

  /// Загружает настройки отображения списка задач.
  Future<TodosViewSettings> getTodosViewSettings();

  /// Сохраняет настройки отображения списка веток.
  Future<void> saveBranchesViewSettings(BranchesViewSettings settings);

  /// Загружает настройки отображения списка веток.
  Future<BranchesViewSettings> getBranchesViewSettings();

  /// Сохраняет последний поисковый запрос во Flickr.
  Future<void> saveLastFlickrQuery(String query);

  /// Загружает последний поисковый запрос во Flickr.
  Future<String> getLastFlickrQuery();
}
