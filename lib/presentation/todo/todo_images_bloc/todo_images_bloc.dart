import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

part 'todo_images_event.dart';
part 'todo_images_state.dart';

/// BLoC для управления картинками задачи.
class TodoImagesBloc extends Bloc<TodoImagesEvent, TodoImagesState> {
  /// Задача.
  final Todo _todo;

  /// Интерактор для взаимодействия с пунктами.
  final TodosInteractor _todosInteractor;

  TodoImagesBloc(ITodosRepository todosRepository, this._todo)
      : _todosInteractor =
            TodosInteractor(todosRepository, NotificationsService()),
        super(TodoImagesLoadingState());

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
    final imagesPaths = await _todosInteractor.getImagesPaths(_todo.id);
    yield TodoImagesContentState(imagesPaths);
  }

  Stream<TodoImagesState> _mapImageAddedEventToState(
    ImageAddedEvent event,
  ) async* {
    try {
      await _todosInteractor.addImagePath(_todo.id, event.tmpPath);
      final imagesPaths = await _todosInteractor.getImagesPaths(_todo.id);
      yield TodoImagesContentState(imagesPaths);
    } catch (_) {
      yield FailedToAddImageState(state.imagesPaths);
    }
  }

  Stream<TodoImagesState> _mapImageDeletedEventToState(
    ImageDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteImagePath(_todo.id, event.path);
    final imagesPaths = await _todosInteractor.getImagesPaths(_todo.id);
    yield TodoImagesContentState(imagesPaths);
  }
}
