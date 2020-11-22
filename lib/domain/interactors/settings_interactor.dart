import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/services/i_settings_storage.dart';

/// Интерактор для работы с настройками пользователя.
class SettingsInteractor {
  /// Хранилище настроек.
  final ISettingsStorage _settingsStorage;

  const SettingsInteractor(this._settingsStorage);

  /// Сохраняет настройки отображения списка задач.
  Future<void> saveTodosViewSettings(TodosViewSettings settings) async {
    return _settingsStorage.saveTodosViewSettings(settings);
  }

  /// Загружает настройки отображения списка задач.
  Future<TodosViewSettings> getTodosViewSettings() async {
    return _settingsStorage.getTodosViewSettings();
  }

  /// Сохраняет настройки отображения списка веток.
  Future<void> saveBranchesViewSettings(
    BranchesViewSettings settings,
  ) async {
    return _settingsStorage.saveBranchesViewSettings(settings);
  }

  /// Загружает настройки отображения списка веток.
  Future<BranchesViewSettings> getBranchesViewSettings() async {
    return _settingsStorage.getBranchesViewSettings();
  }

  /// Сохраняет последний поисковый запрос во Flickr.
  Future<void> saveLastFlickrQuery(String query) async {
    return _settingsStorage.saveLastFlickrQuery(query);
  }

  /// Загружает последний поисковый запрос во Flickr.
  Future<String> getLastFlickrQuery() async {
    return _settingsStorage.getLastFlickrQuery();
  }
}
