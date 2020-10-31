import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

part 'todos_list_event.dart';
part 'todos_list_state.dart';

/// BLoC, управляющий состоянием списка задач.
class TodosListBloc extends Bloc<TodosListEvent, TodosListState> {
  /// Интерактор для взаимодействия с задачами.
  final TodosInteractor _todosInteractor;

  /// Идентификатор ветки задач.
  ///
  /// Может быть равен null.
  final String branchId;

  /// Создает BLoC и загружает список задач.
  TodosListBloc(ITodosRepository todosRepository, {this.branchId})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(TodosListLoadingState()) {
    _todosInteractor
        .getTodos(branchId: branchId)
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
      final todos = await _todosInteractor.getTodos(branchId: branchId);
      yield TodosListUsingState(todos);
    }
  }

  Stream<TodosListState> _mapTodoEditedEventToState(
      TodoEditedEvent event) async* {
    if (state is TodosListUsingState) {
      await _todosInteractor.editTodo(event.todo);
      final todos = await _todosInteractor.getTodos(branchId: branchId);
      yield TodosListUsingState(todos);
    }
  }

  Stream<TodosListState> _mapTodoAddedEventToState(
      TodoAddedEvent event) async* {
    if (state is TodosListUsingState) {
      // TODO: Убрать заглушку branchId после реализации веток.
      var mockBranchId = branchId;
      if (mockBranchId == null) {
        if ((await _todosInteractor.getBranches()).isEmpty) {
          await _todosInteractor.addBranch(Branch('branch'));
        }
        mockBranchId = (await _todosInteractor.getBranches())[0].id;
      }
      await _todosInteractor.addTodo(mockBranchId, event.todo);
      final todos = await _todosInteractor.getTodos(branchId: branchId);
      yield TodosListUsingState(todos);
    }
  }
}
