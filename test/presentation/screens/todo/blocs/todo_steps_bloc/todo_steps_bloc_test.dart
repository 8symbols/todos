import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_steps_bloc/todo_steps_bloc.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodoStepsBloc', () {
    TodosInteractor todosInteractor;

    setUp(() async {
      todosInteractor = MockTodosInteractor();
    });

    blocTest<TodoStepsBloc, TodoStepsState>(
      'не изменяет состояние, если не приходят события',
      build: () {
        return TodoStepsBloc(todosInteractor, Todo(''));
      },
      expect: [],
    );

    blocTest<TodoStepsBloc, TodoStepsState>(
      'загружает шаги',
      build: () {
        when(todosInteractor.getStepsOfTodo(any)).thenAnswer((_) async => []);

        return TodoStepsBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(StepsLoadingRequestedEvent()),
      expect: [isA<StepsContentState>()],
      verify: (_) => verify(todosInteractor.getStepsOfTodo(any)),
    );

    blocTest<TodoStepsBloc, TodoStepsState>(
      'добавляет шаг',
      build: () {
        when(todosInteractor.getStepsOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.addTodoStep(any, any)).thenAnswer((_) async {});

        return TodoStepsBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(StepAddedEvent(TodoStep(''))),
      expect: [isA<StepAddedState>()],
      verify: (_) => verify(todosInteractor.addTodoStep(any, any)),
    );

    blocTest<TodoStepsBloc, TodoStepsState>(
      'изменяет шаг',
      build: () {
        when(todosInteractor.getStepsOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.editTodoStep(any)).thenAnswer((_) async {});

        return TodoStepsBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(StepEditedEvent(TodoStep(''))),
      expect: [isA<StepsContentState>()],
      verify: (_) => verify(todosInteractor.editTodoStep(any)),
    );

    blocTest<TodoStepsBloc, TodoStepsState>(
      'удаляет шаг',
      build: () {
        when(todosInteractor.getStepsOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.deleteTodoStep(any)).thenAnswer((_) async {});

        return TodoStepsBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(StepDeletedEvent('')),
      expect: [isA<StepsContentState>()],
      verify: (_) => verify(todosInteractor.deleteTodoStep(any)),
    );

    blocTest<TodoStepsBloc, TodoStepsState>(
      'удаляет выполненные шаги',
      build: () {
        when(todosInteractor.getStepsOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.deleteCompletedStepsOfTodo(any))
            .thenAnswer((_) async {});

        return TodoStepsBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(CompletedStepsDeletedEvent()),
      expect: [isA<StepsContentState>()],
      verify: (_) => verify(todosInteractor.deleteCompletedStepsOfTodo(any)),
    );
  });
}
