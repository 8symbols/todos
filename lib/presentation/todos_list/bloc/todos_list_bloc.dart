import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/data/repositories/todos_repository/models/branch.dart';
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
    } else if (event is TodoAdded) {
      yield* _mapTodoAddedEventToState(event);
    } else if (event is ShouldShowFabChanged) {
      yield* _mapShouldShowFabChangedEventToState(event);
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
      final currentState = state as TodosListUsing;
      final currentTodos = currentState.todos;
      final newTodos = currentTodos.where((e) => e.id != event.todoId).toList();
      yield currentState.copyWith(todos: newTodos);
    }
  }

  Stream<TodosListState> _mapTodoEditedEventToState(TodoEdited event) async* {
    if (state is TodosListUsing) {
      await _todosInteractor.editTodo(event.todoId, event.todo);
      final currentState = state as TodosListUsing;
      final currentTodos = currentState.todos;
      final newTodos = currentTodos
          .map((e) =>
              e.id == event.todoId ? event.todo.copyWith(id: event.todoId) : e)
          .toList();
      yield currentState.copyWith(todos: newTodos);
    }
  }

  Stream<TodosListState> _mapTodoAddedEventToState(TodoAdded event) async* {
    if (state is TodosListUsing) {
      // TODO: Убрать заглушку branchId после реализации веток.
      var branchId = this.branchId;
      if (branchId == null) {
        if ((await _todosInteractor.getBranches()).isEmpty) {
          await _todosInteractor.addBranch(Branch(title: 'branch'));
        }
        branchId = (await _todosInteractor.getBranches())[0].id;
      }
      await _todosInteractor.addTodo(branchId, event.todo);
      final currentState = state as TodosListUsing;
      final currentTodos = currentState.todos;
      final newTodos = List<Todo>.from(currentTodos)..add(event.todo);
      yield currentState.copyWith(todos: newTodos);
    }
  }

  Stream<TodosListState> _mapShouldShowFabChangedEventToState(
    ShouldShowFabChanged event,
  ) async* {
    if (state is TodosListUsing) {
      final currentState = state as TodosListUsing;
      yield currentState.copyWith(shouldShowFAB: event.shouldShowFab);
    }
  }
}
