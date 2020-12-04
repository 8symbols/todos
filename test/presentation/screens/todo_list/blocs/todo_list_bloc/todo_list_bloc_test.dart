import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/models/todo_data.dart';
import 'package:todos/presentation/screens/todo_list/blocs/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/screens/todo_list/models/todo_statistics.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

class MockSettingsInteractor extends Mock implements SettingsInteractor {}

void main() {
  group('TodoListBloc', () {
    TodosInteractor todosInteractor;
    SettingsInteractor settingsInteractor;

    setUp(() async {
      todosInteractor = MockTodosInteractor();
      settingsInteractor = MockSettingsInteractor();

      when(todosInteractor.getTodos()).thenAnswer((_) async => []);
      when(todosInteractor.getStepsOfTodo(any)).thenAnswer((_) async => []);
      when(todosInteractor.applyTodosViewSettings(any, any)).thenReturn([]);
      when(settingsInteractor.getTodosViewSettings())
          .thenAnswer((_) async => TodosViewSettings());
    });

    blocTest<TodoListBloc, TodoListState>(
      'не изменяет состояние, если не приходят события',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      expect: [],
    );

    blocTest<TodoListBloc, TodoListState>(
      'инициализирует список задач',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      act: (bloc) => bloc.add(InitializationRequestedEvent()),
      expect: [isA<TodoListContentState>()],
      verify: (_) => verify(settingsInteractor.getTodosViewSettings()),
    );

    blocTest<TodoListBloc, TodoListState>(
      'обновляет список задач',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(TodoListOutdatedEvent()),
      skip: 1,
      expect: [isA<TodoListUpdatedState>()],
    );

    blocTest<TodoListBloc, TodoListState>(
      'обновляет настройки отображения',
      build: () {
        when(settingsInteractor.saveTodosViewSettings(any))
            .thenAnswer((_) async {});

        return TodoListBloc(todosInteractor, settingsInteractor);
      },
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(ViewSettingsChangedEvent(TodosViewSettings())),
      skip: 1,
      expect: [isA<TodoListContentState>()],
      verify: (_) => verify(settingsInteractor.saveTodosViewSettings(any)),
    );

    blocTest<TodoListBloc, TodoListState>(
      'добавляет задачу',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(TodoAddedEvent(Todo(''))),
      skip: 1,
      expect: [isA<TodoListContentState>()],
      verify: (_) => verify(todosInteractor.addTodo(any, any)),
    );

    blocTest<TodoListBloc, TodoListState>(
      'изменяет задачу',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      act: (bloc) => bloc
        ..add(InitializationRequestedEvent())
        ..add(TodoEditedEvent(Todo(''))),
      skip: 1,
      expect: [isA<TodoListContentState>()],
      verify: (_) => verify(todosInteractor.editTodo(any)),
    );

    blocTest<TodoListBloc, TodoListState>(
      'удаляет задачу',
      build: () {
        when(todosInteractor.getBranchOfTodo(any)).thenAnswer(
          (_) async => Branch('', BranchThemes.defaultBranchTheme),
        );
        return TodoListBloc(todosInteractor, settingsInteractor);
      },
      seed: TodoListContentState(
        [TodoStatistics(Todo(''), 0, 0)],
        TodosViewSettings(),
      ),
      act: (bloc) => bloc.add(TodoDeletedEvent(Todo(''))),
      expect: [
        isA<TodoListTodoDeletingState>(),
        isA<TodoListTodoDeletedState>(),
      ],
      verify: (_) {
        verify(todosInteractor.makeTodoRestorable(any));
        verify(todosInteractor.deleteTodo(any, isRestorable: true));
      },
    );

    blocTest<TodoListBloc, TodoListState>(
      'восстанавливает задачу',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      act: (bloc) {
        bloc
          ..add(InitializationRequestedEvent())
          ..add(TodoRestoredEvent(
            TodoData(
              branchId: '',
              todo: Todo(''),
              todoImages: [],
              todoSteps: [],
            ),
          ));
      },
      skip: 1,
      expect: [
        isA<TodoListContentState>(),
      ],
      verify: (_) {
        verify(todosInteractor.addTodo(any, any));
      },
    );

    blocTest<TodoListBloc, TodoListState>(
      'удаляет выполненные задачи',
      build: () => TodoListBloc(todosInteractor, settingsInteractor),
      act: (bloc) {
        bloc
          ..add(InitializationRequestedEvent())
          ..add(CompletedTodosDeletedEvent());
      },
      skip: 1,
      expect: [
        isA<TodoListContentState>(),
      ],
      verify: (_) => verify(todosInteractor.deleteCompletedTodos()),
    );
  });
}
