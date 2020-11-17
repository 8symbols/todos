import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/services/i_settings_storage.dart';

/// Интерактор для работы с настройками пользователя.
class SettingsInteractor {
  /// Хранилище настроек.
  final ISettingsStorage _settingsStorage;

  const SettingsInteractor(this._settingsStorage);

  /// Сохраняет настройки отображения списка задач.
  Future<void> saveTodoListViewSettings(TodoListViewSettings settings) async {
    return _settingsStorage.saveTodoListViewSettings(settings);
  }

  /// Загружает настройки отображения списка задач.
  Future<TodoListViewSettings> getTodoListViewSettings() async {
    return _settingsStorage.getTodoListViewSettings();
  }
}
