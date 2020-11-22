import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodosInteractor _todosInteractor;

  TodoBloc(ITodosRepository todosRepository,
      INotificationsService notificationsService, Todo todo)
      : _todosInteractor = TodosInteractor(todosRepository),
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
    await _todosInteractor.editTodo(event.todo);
    final editedTodo = await _todosInteractor.getTodo(event.todo.id);
    yield TodoContentState(editedTodo);
  }

  /// Удаляет задачу.
  Stream<TodoState> _mapTodoDeletedEventToState(
    TodoDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteTodo(state.todo.id);
    yield TodoDeletedState();
  }
}
