import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/services/i_settings_storage.dart';

class MockSettingsStorage extends Mock implements ISettingsStorage {}

void main() {
  group('SettingsInteractor', () {
    ISettingsStorage storage;

    setUp(() {
      storage = MockSettingsStorage();
    });

    test('получает последний запрос в Flickr', () async {
      final interactor = SettingsInteractor(storage);
      await interactor.getLastFlickrQuery();
      verify(storage.getLastFlickrQuery());
    });

    test('получает настройки отображения списка задач', () async {
      final interactor = SettingsInteractor(storage);
      await interactor.getTodosViewSettings();
      verify(storage.getTodosViewSettings());
    });

    test('получает настройки отображения списка веток', () async {
      final interactor = SettingsInteractor(storage);
      await interactor.getBranchesViewSettings();
      verify(storage.getBranchesViewSettings());
    });

    test('сохраняет последний запрос в Flickr', () async {
      final interactor = SettingsInteractor(storage);
      await interactor.saveLastFlickrQuery('');
      verify(storage.saveLastFlickrQuery(any));
    });

    test('сохраняет настройки отображения списка задач', () async {
      final interactor = SettingsInteractor(storage);
      await interactor.saveTodosViewSettings(TodosViewSettings());
      verify(storage.saveTodosViewSettings(any));
    });

    test('сохраняет настройки отображения списка веток', () async {
      final interactor = SettingsInteractor(storage);
      await interactor.saveBranchesViewSettings(BranchesViewSettings());
      verify(storage.saveBranchesViewSettings(any));
    });
  });
}
