import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/services/i_settings_storage.dart';

/// Хранилище настроек в [SharedPreferences].
class SettingsStorage implements ISettingsStorage {
  static const _todoListViewSettingsKey = 'todo_list_view_settings';

  static const _lastFlickrQueryKey = 'last_flickr_query';

  Future<SharedPreferences> _futurePrefs = SharedPreferences.getInstance();

  @override
  Future<void> saveTodoListViewSettings(TodoListViewSettings settings) async {
    final prefs = await _futurePrefs;
    prefs.setString(_todoListViewSettingsKey, jsonEncode(settings));
  }

  @override
  Future<TodoListViewSettings> getTodoListViewSettings() async {
    final prefs = await _futurePrefs;
    final json = prefs.getString(_todoListViewSettingsKey);
    return json != null
        ? TodoListViewSettings.fromJson(jsonDecode(json))
        : TodoListViewSettings();
  }

  @override
  Future<void> saveLastFlickrQuery(String query) async {
    final prefs = await _futurePrefs;
    prefs.setString(_lastFlickrQueryKey, query);
  }

  @override
  Future<String> getLastFlickrQuery() async {
    final prefs = await _futurePrefs;
    return prefs.getString(_lastFlickrQueryKey) ?? '';
  }
}
