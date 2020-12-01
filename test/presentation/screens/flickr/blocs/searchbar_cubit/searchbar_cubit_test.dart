import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/presentation/screens/flickr/blocs/searchbar_cubit/searchbar_cubit.dart';
import 'package:todos/presentation/screens/flickr/blocs/searchbar_cubit/searchbar_state.dart';

class MockSettingsInteractor extends Mock implements SettingsInteractor {}

void main() {
  group('SearchBarCubit', () {
    SettingsInteractor settingsInteractor;

    setUp(() {
      settingsInteractor = MockSettingsInteractor();
      when(settingsInteractor.saveLastFlickrQuery(any))
          .thenAnswer((_) async {});
      when(settingsInteractor.getLastFlickrQuery()).thenAnswer((_) async => '');
    });

    blocTest<SearchBarCubit, SearchBarState>(
      'не изменяет состояние, если не приходят события',
      build: () => SearchBarCubit(settingsInteractor),
      expect: [],
    );

    blocTest<SearchBarCubit, SearchBarState>(
      'сохраняет последний поисковый запрос',
      build: () => SearchBarCubit(settingsInteractor),
      act: (cubit) => cubit.saveLastQuery(''),
      expect: [],
      verify: (_) => verify(settingsInteractor.saveLastFlickrQuery(any)),
    );

    blocTest<SearchBarCubit, SearchBarState>(
      'открывает строку поиска',
      build: () => SearchBarCubit(settingsInteractor),
      act: (cubit) => cubit.showSearchBar(),
      expect: [
        predicate((state) => state.shouldShow),
      ],
      verify: (_) => verify(settingsInteractor.getLastFlickrQuery()),
    );

    blocTest<SearchBarCubit, SearchBarState>(
      'закрывает строку поиска',
      build: () => SearchBarCubit(settingsInteractor),
      act: (cubit) => cubit.hideSearchBar(),
      expect: [
        predicate((state) => !state.shouldShow),
      ],
    );
  });
}
