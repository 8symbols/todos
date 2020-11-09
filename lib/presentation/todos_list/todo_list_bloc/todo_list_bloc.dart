import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/todos_list/models/todo_card_data.dart';
import 'package:todos/domain/models/todos_sort_order.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

/// BLoC, управляющий состоянием списка задач.
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  /// Интерактор для взаимодействия с задачами.
  final TodosInteractor _todosInteractor;

  /// Ветка задача.
  ///
  /// Может быть равна null.
  final String branchId;

  /// Порядок сортировки задач.
  TodosSortOrder _sortOrder = TodosSortOrder.creation;

  /// Создает BLoC.
  TodoListBloc(ITodosRepository todosRepository, {this.branchId})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(TodosListLoadingState(true));

  @override
  Stream<TodoListState> mapEventToState(
    TodoListEvent event,
  ) async* {
    if (event is TodosListLoadingRequestedEvent) {
      yield* _mapTodosListLoadingRequestedEventToState(event);
    } else if (event is TodoDeletedEvent) {
      yield* _mapTodoDeletedEventToState(event);
    } else if (event is TodoEditedEvent) {
      yield* _mapTodoEditedEventToState(event);
    } else if (event is TodoAddedEvent) {
      yield* _mapTodoAddedEventToState(event);
    } else if (event is CompletedTodosVisibilityChangedEvent) {
      yield* _mapCompletedTodosVisibilityChangedEventToState(event);
    } else if (event is CompletedTodosDeletedEvent) {
      yield* _mapCompletedTodosDeletedEventToState(event);
    } else if (event is TodosSortOrderChangedEvent) {
      yield* _mapTodosSortOrderChangedEventToState(event);
    }
  }

  /// Загружает список задач.
  Stream<TodoListState> _mapTodosListLoadingRequestedEventToState(
    TodosListLoadingRequestedEvent event,
  ) async* {
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListContentState(
        await _mapToViewData(todos), state.areCompletedTodosVisible);
  }

  /// Удаляет задачу.
  Stream<TodoListState> _mapTodoDeletedEventToState(
    TodoDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteTodo(event.todo.id);
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListDeletedTodoState(event.todo, await _mapToViewData(todos),
        state.areCompletedTodosVisible);
  }

  /// Изменяет задачу.
  Stream<TodoListState> _mapTodoEditedEventToState(
    TodoEditedEvent event,
  ) async* {
    await _todosInteractor.editTodo(event.todo);
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListContentState(
        await _mapToViewData(todos), state.areCompletedTodosVisible);
  }

  /// Добавляет задачу.
  Stream<TodoListState> _mapTodoAddedEventToState(
    TodoAddedEvent event,
  ) async* {
    // TODO: Убрать заглушку branchId после реализации веток.
    var mockBranchId = branchId;
    if (mockBranchId == null) {
      mockBranchId = (await _todosInteractor.getBranches())[0].id;
    }
    await _todosInteractor.addTodo(mockBranchId, event.todo);
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListContentState(
        await _mapToViewData(todos), state.areCompletedTodosVisible);
  }

  /// Применяет к списку задач настройки отображения выполненных задач.
  Stream<TodoListState> _mapCompletedTodosVisibilityChangedEventToState(
    CompletedTodosVisibilityChangedEvent event,
  ) async* {
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListContentState(
        await _mapToViewData(todos,
            areCompletedTodosVisible: event.areCompletedTodosVisible),
        event.areCompletedTodosVisible);
  }

  /// Удаляет выполненные задачи.
  Stream<TodoListState> _mapCompletedTodosDeletedEventToState(
    CompletedTodosDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteCompletedTodos(branchId: branchId);
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListContentState(
        await _mapToViewData(todos), state.areCompletedTodosVisible);
  }

  /// Сортирует в соответствии с новым порядком сортировки.
  Stream<TodoListState> _mapTodosSortOrderChangedEventToState(
    TodosSortOrderChangedEvent event,
  ) async* {
    _sortOrder = event.sortOrder;
    final todos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodosListContentState(
        await _mapToViewData(todos), state.areCompletedTodosVisible);
  }

  /// Применяет настройки отображения: удаляет выполненные задачи,
  /// если установлен флаг [areCompletedTodosVisible], и сортирует
  /// в соответствии с [TodoListBloc._sortOrder].
  List<Todo> _applyViewSettings(
    List<Todo> todos,
    bool areCompletedTodosVisible,
  ) {
    if (!areCompletedTodosVisible) {
      todos = todos.where((todo) => !todo.wasCompleted).toList();
    }

    _todosInteractor.sortTodos(todos, _sortOrder);
    return todos;
  }

  /// Загружает информацию о каждой задаче.
  Future<List<TodoViewData>> _loadViewData(List<Todo> todos) async {
    final futureTodos = todos.map((todo) async {
      final steps = await _todosInteractor.getSteps(todo.id);
      final completedStepsCount =
          steps.where((step) => step.wasCompleted).length;
      return TodoViewData(todo, steps.length, completedStepsCount);
    });

    return Future.wait(futureTodos);
  }

  /// Применяет настройки отображения и загружает информацию о каждой задаче.
  ///
  /// Если не указано, нужно ли включать в список выполненные задачи,
  /// берется настройка из [TodoListState.areCompletedTodosVisible].
  Future<List<TodoViewData>> _mapToViewData(List<Todo> todos,
      {bool areCompletedTodosVisible}) async {
    areCompletedTodosVisible ??= state.areCompletedTodosVisible;
    final filteredTodos = _applyViewSettings(todos, areCompletedTodosVisible);
    return await _loadViewData(filteredTodos);
  }
}
