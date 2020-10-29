import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

part 'todos_list_event.dart';
part 'todos_list_state.dart';

class TodosListBloc extends Bloc<TodosListEvent, TodosListState> {
  final TodosInteractor _todosInteractor;
  final String branchId;

  TodosListBloc(ITodosRepository todosRepository, {this.branchId})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(TodosListLoadingState()) {
    _todosInteractor
        .getTodos()
        .then((todos) => add(TodosListLoadedEvent(todos)));
  }

  @override
  Stream<TodosListState> mapEventToState(
    TodosListEvent event,
  ) async* {
    if (event is TodosListLoadedEvent) {
      yield* _mapTodosListLoadedEventToState(event);
    } else if (event is TodoDeletedEvent) {
      yield* _mapTodoDeletedEventToState(event);
    } else if (event is TodoEditedEvent) {
      yield* _mapTodoEditedEventToState(event);
    } else if (event is TodoAddedEvent) {
      yield* _mapTodoAddedEventToState(event);
    } else if (event is ShouldShowFabChangedEvent) {
      yield* _mapShouldShowFabChangedEventToState(event);
    }
  }

  Stream<TodosListState> _mapTodosListLoadedEventToState(
    TodosListLoadedEvent event,
  ) async* {
    yield TodosListUsingState(event.todos);
  }

  Stream<TodosListState> _mapTodoDeletedEventToState(
      TodoDeletedEvent event) async* {
    if (state is TodosListUsingState) {
      await _todosInteractor.deleteTodo(event.todoId);
      final currentState = state as TodosListUsingState;
      final currentTodos = currentState.todos;
      final newTodos = currentTodos.where((e) => e.id != event.todoId).toList();
      yield currentState.copyWith(todos: newTodos);
    }
  }

  Stream<TodosListState> _mapTodoEditedEventToState(
      TodoEditedEvent event) async* {
    if (state is TodosListUsingState) {
      await _todosInteractor.editTodo(event.todoId, event.todo);
      final currentState = state as TodosListUsingState;
      final currentTodos = currentState.todos;
      final newTodos = currentTodos
          .map((e) =>
              e.id == event.todoId ? event.todo.copyWith(id: event.todoId) : e)
          .toList();
      yield currentState.copyWith(todos: newTodos);
    }
  }

  Stream<TodosListState> _mapTodoAddedEventToState(
      TodoAddedEvent event) async* {
    if (state is TodosListUsingState) {
      // TODO: Убрать заглушку branchId после реализации веток.
      var branchId = this.branchId;
      if (branchId == null) {
        if ((await _todosInteractor.getBranches()).isEmpty) {
          await _todosInteractor.addBranch(Branch('branch'));
        }
        branchId = (await _todosInteractor.getBranches())[0].id;
      }
      await _todosInteractor.addTodo(branchId, event.todo);
      final currentState = state as TodosListUsingState;
      final currentTodos = currentState.todos;
      final newTodos = List<Todo>.from(currentTodos)..add(event.todo);
      yield currentState.copyWith(todos: newTodos);
    }
  }

  Stream<TodosListState> _mapShouldShowFabChangedEventToState(
    ShouldShowFabChangedEvent event,
  ) async* {
    if (state is TodosListUsingState) {
      final currentState = state as TodosListUsingState;
      yield currentState.copyWith(shouldShowFAB: event.shouldShowFab);
    }
  }
}
