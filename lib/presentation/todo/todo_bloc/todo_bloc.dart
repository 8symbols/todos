import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/notifications_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodosInteractor _todosInteractor;

  final NotificationsInteractor _notificationsInteractor;

  TodoBloc(ITodosRepository todosRepository,
      INotificationsService notificationsService, Todo todo)
      : _todosInteractor = TodosInteractor(todosRepository),
        _notificationsInteractor =
            NotificationsInteractor(notificationsService),
        super(TodoContentState(todo));

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is TodoEditedEvent) {
      yield* _mapTodoEditedEventToState(event);
    } else if (event is TodoDeletedEvent) {
      yield* _mapTodoDeletedEventToState(event);
    }
  }

  /// Изменяет задачу.
  Stream<TodoState> _mapTodoEditedEventToState(
    TodoEditedEvent event,
  ) async* {
    if (state.todo.notificationTime != event.todo.notificationTime) {
      if (event.todo.notificationTime != null) {
        await _notificationsInteractor.scheduleNotification(event.todo);
      } else {
        await _notificationsInteractor.cancelNotification(event.todo);
      }
    }
    await _todosInteractor.editTodo(event.todo);
    yield TodoContentState(event.todo);
  }

  /// Удаляет задачу.
  Stream<TodoState> _mapTodoDeletedEventToState(
    TodoDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteTodo(state.todo.id);
    yield TodoDeletedState();
  }
}
