import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/branches/blocs/branches_bloc/branches_bloc.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

class MockSettingsInteractor extends Mock implements SettingsInteractor {}

void main() {
  group('BranchesBloc', () {
    TodosInteractor todosInteractor;
    SettingsInteractor settingsInteractor;

    setUp(() async {
      todosInteractor = MockTodosInteractor();
      settingsInteractor = MockSettingsInteractor();

      when(todosInteractor.getBranches()).thenAnswer((_) async => []);
      when(todosInteractor.applyBranchesViewSettings(any, any)).thenReturn([]);
    });

    blocTest<BranchesBloc, BranchesState>(
      'не изменяет состояние, если не приходят события',
      build: () {
        when(settingsInteractor.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(todosInteractor, settingsInteractor);
      },
      expect: [],
    );

    blocTest<BranchesBloc, BranchesState>(
      'инициализирует список веток',
      build: () {
        when(settingsInteractor.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(todosInteractor, settingsInteractor);
      },
      act: (bloc) => bloc.add(InitializationRequestedEvent()),
      expect: [isA<BranchesContentState>()],
      verify: (_) => verify(settingsInteractor.getBranchesViewSettings()),
    );

    blocTest<BranchesBloc, BranchesState>(
      'обновляет список веток',
      build: () {
        when(settingsInteractor.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(todosInteractor, settingsInteractor);
      },
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(BranchesOutdatedEvent()),
      skip: 1,
      expect: [isA<BranchesContentState>()],
    );

    blocTest<BranchesBloc, BranchesState>(
      'обновляет настройки отображения',
      build: () {
        when(settingsInteractor.saveBranchesViewSettings(any))
            .thenAnswer((_) async {});
        when(settingsInteractor.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(todosInteractor, settingsInteractor);
      },
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(ViewSettingsChangedEvent(BranchesViewSettings())),
      skip: 1,
      expect: [isA<BranchesContentState>()],
      verify: (_) => verify(settingsInteractor.saveBranchesViewSettings(any)),
    );

    blocTest<BranchesBloc, BranchesState>(
      'добавляет ветку',
      build: () {
        when(settingsInteractor.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(todosInteractor, settingsInteractor);
      },
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(BranchAddedEvent(Branch('', BranchThemes.defaultBranchTheme))),
      skip: 1,
      expect: [isA<BranchesContentState>()],
    );

    blocTest<BranchesBloc, BranchesState>(
      'удаляет ветку',
      build: () {
        when(settingsInteractor.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(todosInteractor, settingsInteractor);
      },
      act: (bloc) {
        final branch = Branch('', BranchThemes.defaultBranchTheme);
        bloc
          ..add(InitializationRequestedEvent())
          ..add(BranchAddedEvent(branch))
          ..add(BranchDeletedEvent(branch));
      },
      skip: 2,
      expect: [isA<BranchesContentState>()],
    );
  });
}
