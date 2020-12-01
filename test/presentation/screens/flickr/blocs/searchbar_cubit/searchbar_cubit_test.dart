import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/screens/flickr/blocs/searchbar_cubit/searchbar_cubit.dart';
import 'package:todos/presentation/screens/flickr/blocs/searchbar_cubit/searchbar_state.dart';

class MockSettingsStorage extends Mock implements ISettingsStorage {}

void main() {
  group('SearchBarCubit', () {
    ISettingsStorage settingsStorage;

    setUp(() {
      settingsStorage = MockSettingsStorage();
      when(settingsStorage.saveLastFlickrQuery(any)).thenAnswer((_) async {});
      when(settingsStorage.getLastFlickrQuery()).thenAnswer((_) async => '');
    });

    blocTest<SearchBarCubit, SearchBarState>(
      'не изменяет состояние, если не приходят события',
      build: () => SearchBarCubit(settingsStorage),
      expect: [],
    );

    blocTest<SearchBarCubit, SearchBarState>(
      'сохраняет последний поисковый запрос',
      build: () => SearchBarCubit(settingsStorage),
      act: (cubit) => cubit.saveLastQuery(''),
      expect: [],
      verify: (_) => verify(settingsStorage.saveLastFlickrQuery(any)),
    );

    blocTest<SearchBarCubit, SearchBarState>(
      'открывает строку поиска',
      build: () => SearchBarCubit(settingsStorage),
      act: (cubit) => cubit.showSearchBar(),
      expect: [
        predicate((state) => state.shouldShow),
      ],
      verify: (_) => verify(settingsStorage.getLastFlickrQuery()),
    );

    blocTest<SearchBarCubit, SearchBarState>(
      'закрывает строку поиска',
      build: () => SearchBarCubit(settingsStorage),
      act: (cubit) => cubit.hideSearchBar(),
      expect: [
        predicate((state) => !state.shouldShow),
      ],
    );
  });
}
