import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/services/i_settings_storage.dart';

/// Хранилище настроек в [SharedPreferences].
class SettingsStorage implements ISettingsStorage {
  static const _todosViewSettingsKey = 'todos_view_settings';

  static const _branchesViewSettingsKey = 'branches_view_settings';

  static const _lastFlickrQueryKey = 'last_flickr_query';

  Future<SharedPreferences> _futurePrefs = SharedPreferences.getInstance();

  @override
  Future<void> saveTodosViewSettings(TodosViewSettings settings) async {
    final prefs = await _futurePrefs;
    prefs.setString(_todosViewSettingsKey, jsonEncode(settings));
  }

  @override
  Future<TodosViewSettings> getTodosViewSettings() async {
    final prefs = await _futurePrefs;
    final json = prefs.getString(_todosViewSettingsKey);
    return json != null
        ? TodosViewSettings.fromJson(jsonDecode(json))
        : TodosViewSettings();
  }

  @override
  Future<void> saveBranchesViewSettings(BranchesViewSettings settings) async {
    final prefs = await _futurePrefs;
    prefs.setString(_branchesViewSettingsKey, jsonEncode(settings));
  }

  @override
  Future<BranchesViewSettings> getBranchesViewSettings() async {
    final prefs = await _futurePrefs;
    final json = prefs.getString(_branchesViewSettingsKey);
    return json != null
        ? BranchesViewSettings.fromJson(jsonDecode(json))
        : BranchesViewSettings();
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
