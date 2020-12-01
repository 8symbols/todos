import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/data/repositories/todos_repository.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/services/i_notifications_service.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/branches/blocs/branches_bloc/branches_bloc.dart';

class MockNotificationService extends Mock implements INotificationsService {}

class MockSettingsStorage extends Mock implements ISettingsStorage {}

void main() {
  group('BranchesBloc', () {
    FloorTodosDatabase database;
    TodosRepository repository;
    ISettingsStorage settingsStorage;
    INotificationsService notificationsService;

    setUp(() async {
      database =
          await $FloorFloorTodosDatabase.inMemoryDatabaseBuilder().build();
      repository = TodosRepository(database);
      settingsStorage = MockSettingsStorage();
      notificationsService = MockNotificationService();
    });

    tearDown(() async {
      await database.close();
    });

    blocTest<BranchesBloc, BranchesState>(
      'не изменяет состояние, если не приходят события',
      build: () {
        when(settingsStorage.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(
          repository,
          settingsStorage,
          notificationsService: notificationsService,
        );
      },
      expect: [],
    );

    blocTest<BranchesBloc, BranchesState>(
      'инициализирует список веток',
      build: () {
        when(settingsStorage.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(
          repository,
          settingsStorage,
          notificationsService: notificationsService,
        );
      },
      act: (bloc) => bloc.add(InitializationRequestedEvent()),
      expect: [isA<BranchesContentState>()],
      verify: (_) => verify(settingsStorage.getBranchesViewSettings()),
    );

    blocTest<BranchesBloc, BranchesState>(
      'обновляет список веток',
      build: () {
        when(settingsStorage.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(
          repository,
          settingsStorage,
          notificationsService: notificationsService,
        );
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
        when(settingsStorage.saveBranchesViewSettings(any))
            .thenAnswer((_) async {});
        when(settingsStorage.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(
          repository,
          settingsStorage,
          notificationsService: notificationsService,
        );
      },
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(ViewSettingsChangedEvent(BranchesViewSettings())),
      skip: 1,
      expect: [isA<BranchesContentState>()],
      verify: (_) => verify(settingsStorage.saveBranchesViewSettings(any)),
    );

    blocTest<BranchesBloc, BranchesState>(
      'добавляет ветку',
      build: () {
        when(settingsStorage.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(
          repository,
          settingsStorage,
          notificationsService: notificationsService,
        );
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
        when(settingsStorage.getBranchesViewSettings())
            .thenAnswer((_) async => BranchesViewSettings());
        return BranchesBloc(
          repository,
          settingsStorage,
          notificationsService: notificationsService,
        );
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
