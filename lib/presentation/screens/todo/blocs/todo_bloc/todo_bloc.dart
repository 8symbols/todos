import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

/// BloC для управления задачей.
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  /// Интерактор для работы с задачей.
  final TodosInteractor _todosInteractor;

  TodoBloc(this._todosInteractor, Todo todo) : super(TodoContentState(todo));

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
