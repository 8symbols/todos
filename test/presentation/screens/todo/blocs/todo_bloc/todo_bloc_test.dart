import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_bloc/todo_bloc.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodoBloc', () {
    TodosInteractor todosInteractor;

    setUp(() async {
      todosInteractor = MockTodosInteractor();
    });

    blocTest<TodoBloc, TodoState>(
      'не изменяет состояние, если не приходят события',
      build: () {
        return TodoBloc(todosInteractor, Todo(''));
      },
      expect: [],
    );

    blocTest<TodoBloc, TodoState>(
      'изменяет задачу',
      build: () {
        when(todosInteractor.getTodo(any)).thenAnswer((_) async => Todo(''));
        when(todosInteractor.editTodo(any)).thenAnswer((_) async {});

        return TodoBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(TodoEditedEvent(Todo(''))),
      expect: [isA<TodoContentState>()],
      verify: (_) => verify(todosInteractor.editTodo(any)),
    );

    blocTest<TodoBloc, TodoState>(
      'удаляет задачу',
      build: () {
        when(todosInteractor.getTodo(any)).thenAnswer((_) async => Todo(''));
        when(todosInteractor.getImagesOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.deleteTodo(any)).thenAnswer((_) async {});

        return TodoBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(TodoDeletedEvent()),
      expect: [isA<TodoDeletedState>()],
      verify: (_) => verify(todosInteractor.deleteTodo(any)),
    );
  });
}
