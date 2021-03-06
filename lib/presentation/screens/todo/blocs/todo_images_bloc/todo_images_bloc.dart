import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';

part 'todo_images_event.dart';
part 'todo_images_state.dart';

/// BLoC для управления картинками задачи.
class TodoImagesBloc extends Bloc<TodoImagesEvent, TodoImagesState> {
  /// Задача.
  final Todo _todo;

  /// Интерактор для взаимодействия с пунктами.
  final TodosInteractor _todosInteractor;

  TodoImagesBloc(this._todosInteractor, this._todo)
      : super(TodoImagesLoadingState());

  @override
  Stream<TodoImagesState> mapEventToState(
    TodoImagesEvent event,
  ) async* {
    if (event is ImagesLoadingRequestedEvent) {
      yield* _mapImagesLoadingRequestedEventToState(event);
    } else if (event is ImageAddedEvent) {
      yield* _mapImageAddedEventToState(event);
    } else if (event is ImageDeletedEvent) {
      yield* _mapImageDeletedEventToState(event);
    }
  }

  /// Загружает картинки из репозитория.
  Stream<TodoImagesState> _mapImagesLoadingRequestedEventToState(
    ImagesLoadingRequestedEvent event,
  ) async* {
    final imagesPaths = await _todosInteractor.getImagesOfTodo(_todo.id);
    yield TodoImagesContentState(imagesPaths);
  }

  Stream<TodoImagesState> _mapImageAddedEventToState(
    ImageAddedEvent event,
  ) async* {
    try {
      await _todosInteractor.addTodoImage(_todo.id, event.tmpPath);
      final imagesPaths = await _todosInteractor.getImagesOfTodo(_todo.id);
      yield TodoImagesContentState(imagesPaths);
    } catch (_) {
      yield FailedToAddImageState(state.imagesPaths);
    }
  }

  Stream<TodoImagesState> _mapImageDeletedEventToState(
    ImageDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteTodoImage(_todo.id, event.path);
    final imagesPaths = await _todosInteractor.getImagesOfTodo(_todo.id);
    yield TodoImagesContentState(imagesPaths);
  }
}
