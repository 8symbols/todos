import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_bloc/todo_bloc.dart';

class MockNotificationService extends Mock implements INotificationsService {}

class MockSettingsStorage extends Mock implements ISettingsStorage {}

class MockTodosRepository extends Mock implements ITodosRepository {}

void main() {
  group('TodoBloc', () {
    ITodosRepository repository;
    INotificationsService notificationsService;

    setUp(() async {
      repository = MockTodosRepository();
      notificationsService = MockNotificationService();
    });

    blocTest<TodoBloc, TodoState>(
      'не изменяет состояние, если не приходят события',
      build: () {
        return TodoBloc(
          repository,
          Todo(''),
          notificationsService: notificationsService,
        );
      },
      expect: [],
    );

    blocTest<TodoBloc, TodoState>(
      'изменяет задачу',
      build: () {
        when(repository.getTodo(any)).thenAnswer((_) async => Todo(''));
        when(repository.editTodo(any)).thenAnswer((_) async {});

        return TodoBloc(
          repository,
          Todo(''),
          notificationsService: notificationsService,
        );
      },
      act: (bloc) => bloc.add(TodoEditedEvent(Todo(''))),
      expect: [isA<TodoContentState>()],
      verify: (_) => verify(repository.editTodo(any)),
    );

    blocTest<TodoBloc, TodoState>(
      'удаляет задачу',
      build: () {
        when(repository.getTodo(any)).thenAnswer((_) async => Todo(''));
        when(repository.getImagesOfTodo(any)).thenAnswer((_) async => []);
        when(repository.deleteTodo(any)).thenAnswer((_) async {});

        return TodoBloc(
          repository,
          Todo(''),
          notificationsService: notificationsService,
        );
      },
      act: (bloc) => bloc.add(TodoDeletedEvent()),
      expect: [isA<TodoDeletedState>()],
      verify: (_) => verify(repository.deleteTodo(any)),
    );
  });
}
