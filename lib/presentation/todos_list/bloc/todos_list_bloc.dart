import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/data/repositories/todos_repository/models/todo.dart';
import 'package:todos/data/repositories/todos_repository/repositories/i_todos_repository.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';

part 'todos_list_event.dart';
part 'todos_list_state.dart';

class TodosListBloc extends Bloc<TodosListEvent, TodosListState> {
  final TodosInteractor _todosInteractor;
  final String branchId;

  TodosListBloc(ITodosRepository todosRepository, {this.branchId})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(TodosListLoading()) {
    _todosInteractor.getTodos().then((todos) => add(TodosListLoaded(todos)));
  }

  @override
  Stream<TodosListState> mapEventToState(
    TodosListEvent event,
  ) async* {
    if (event is TodosListLoaded) {
      yield* _mapTodosListLoadedEventToState(event);
    } else if (event is TodoDeleted) {
      yield* _mapTodoDeletedEventToState(event);
    } else if (event is TodoEdited) {
      yield* _mapTodoEditedEventToState(event);
    }
  }

  Stream<TodosListState> _mapTodosListLoadedEventToState(
    TodosListLoaded event,
  ) async* {
    yield TodosListUsing(event.todos);
  }

  Stream<TodosListState> _mapTodoDeletedEventToState(TodoDeleted event) async* {
    if (state is TodosListUsing) {
      await _todosInteractor.deleteTodo(event.todoId);
      final currentTodos = (state as TodosListUsing).todos;
      yield TodosListUsing(
          currentTodos.where((e) => e.id != event.todoId).toList());
    }
  }

  Stream<TodosListState> _mapTodoEditedEventToState(TodoEdited event) async* {
    if (state is TodosListUsing) {
      final currentTodos = (state as TodosListUsing).todos;
      final newTodos = currentTodos
          .map((e) =>
              e.id == event.todoId ? event.todo.copyWith(id: event.todoId) : e)
          .toList();
      yield TodosListUsing(newTodos);
    }
  }
}
