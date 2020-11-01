import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

/// BLoC, управляющий состоянием списка задач.
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  /// Интерактор для взаимодействия с задачами.
  final TodosInteractor _todosInteractor;

  /// Идентификатор ветки задач.
  ///
  /// Может быть равен null.
  final String branchId;

  /// Создает BLoC и загружает список задач.
  TodoListBloc(ITodosRepository todosRepository, {this.branchId})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(TodosListLoadingState()) {
    _todosInteractor
        .getTodos(branchId: branchId)
        .then((todos) => add(TodosListLoadedEvent(todos)));
  }

  @override
  Stream<TodoListState> mapEventToState(
    TodoListEvent event,
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

  /// Устанавливает загруженные задачи в состояние.
  Stream<TodoListState> _mapTodosListLoadedEventToState(
    TodosListLoadedEvent event,
  ) async* {
    yield TodosListUsingState(event.todos);
  }

  /// Удаляет задачу.
  Stream<TodoListState> _mapTodoDeletedEventToState(
    TodoDeletedEvent event,
  ) async* {
    if (state is TodosListUsingState) {
      await _todosInteractor.deleteTodo(event.todoId);
      final todos = await _todosInteractor.getTodos(branchId: branchId);
      yield TodosListUsingState(todos);
    }
  }

  /// Изменяет задачу.
  Stream<TodoListState> _mapTodoEditedEventToState(
    TodoEditedEvent event,
  ) async* {
    if (state is TodosListUsingState) {
      await _todosInteractor.editTodo(event.todo);
      final todos = await _todosInteractor.getTodos(branchId: branchId);
      yield TodosListUsingState(todos);
    }
  }

  /// Добавляет задачу.
  Stream<TodoListState> _mapTodoAddedEventToState(
    TodoAddedEvent event,
  ) async* {
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
