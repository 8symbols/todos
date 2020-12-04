import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_images_bloc/todo_images_bloc.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodoImagesBloc', () {
    TodosInteractor todosInteractor;

    setUp(() async {
      todosInteractor = MockTodosInteractor();
    });

    blocTest<TodoImagesBloc, TodoImagesState>(
      'не изменяет состояние, если не приходят события',
      build: () {
        return TodoImagesBloc(todosInteractor, Todo(''));
      },
      expect: [],
    );

    blocTest<TodoImagesBloc, TodoImagesState>(
      'загружает изображения',
      build: () {
        when(todosInteractor.getImagesOfTodo(any)).thenAnswer((_) async => []);

        return TodoImagesBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(ImagesLoadingRequestedEvent()),
      expect: [isA<TodoImagesContentState>()],
      verify: (_) => verify(todosInteractor.getImagesOfTodo(any)),
    );

    blocTest<TodoImagesBloc, TodoImagesState>(
      'добавляет изображение',
      build: () {
        when(todosInteractor.getImagesOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.addTodoImage(any, any)).thenAnswer((_) async {});

        return TodoImagesBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(ImageAddedEvent('')),
      expect: [isA<TodoImagesContentState>()],
      verify: (_) => verify(todosInteractor.addTodoImage(any, any)),
    );

    blocTest<TodoImagesBloc, TodoImagesState>(
      'удаляет изображение',
      build: () {
        when(todosInteractor.getImagesOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.deleteTodoImage(any, any))
            .thenAnswer((_) async {});

        return TodoImagesBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(ImageDeletedEvent('')),
      expect: [isA<TodoImagesContentState>()],
      verify: (_) => verify(todosInteractor.deleteTodoImage(any, any)),
    );

    blocTest<TodoImagesBloc, TodoImagesState>(
      'отлавливает ошибку добавления',
      build: () {
        when(todosInteractor.getImagesOfTodo(any)).thenAnswer((_) async => []);
        when(todosInteractor.addTodoImage(any, any)).thenThrow(Exception());

        return TodoImagesBloc(todosInteractor, Todo(''));
      },
      act: (bloc) => bloc.add(ImageAddedEvent('')),
      expect: [isA<FailedToAddImageState>()],
      verify: (_) => verify(todosInteractor.addTodoImage(any, any)),
    );
  });
}
