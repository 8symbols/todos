import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/presentation/models/todo_data.dart';
import 'package:todos/presentation/screens/todos_list/models/todo_statistics.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

/// BLoC, управляющий состоянием списка задач.
class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  /// Интерактор для взаимодействия с задачами.
  final TodosInteractor _todosInteractor;

  /// Интерактор для взаимодействия с настройками.
  final SettingsInteractor _settingsInteractor;

  /// Ветка задача.
  ///
  /// Может быть равна null.
  final String branchId;

  List<Todo> _allTodos;

  TodoListBloc(
    this._todosInteractor,
    this._settingsInteractor, {
    this.branchId,
  }) : super(TodoListLoadingState());

  @override
  Stream<TodoListState> mapEventToState(
    TodoListEvent event,
  ) async* {
    if (event is InitializationRequestedEvent) {
      yield* _mapInitializationRequestedEventToState(event);
    } else if (event is TodoListOutdatedEvent) {
      yield* _mapTodoListOutdatedEventToState(event);
    } else if (event is TodoDeletedEvent) {
      yield* _mapTodoDeletedEventToState(event);
    } else if (event is TodoEditedEvent) {
      yield* _mapTodoEditedEventToState(event);
    } else if (event is TodoAddedEvent) {
      yield* _mapTodoAddedEventToState(event);
    } else if (event is TodoRestoredEvent) {
      yield* _mapTodoRestoredEventToState(event);
    } else if (event is CompletedTodosDeletedEvent) {
      yield* _mapCompletedTodosDeletedEventToState(event);
    } else if (event is ViewSettingsChangedEvent) {
      yield* _mapViewSettingsChangedEventToState(event);
    }
  }

  /// Загружает настройки списка задач и список задач.
  Stream<TodoListState> _mapInitializationRequestedEventToState(
    InitializationRequestedEvent event,
  ) async* {
    final settings = await _settingsInteractor.getTodosViewSettings();
    _allTodos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodoListContentState(await _mapTodosToView(settings), settings);
  }

  /// Загружает список задач.
  Stream<TodoListState> _mapTodoListOutdatedEventToState(
    TodoListOutdatedEvent event,
  ) async* {
    _allTodos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodoListUpdatedState(await _mapTodosToView(), state.viewSettings);
  }

  /// Удаляет задачу.
  Stream<TodoListState> _mapTodoDeletedEventToState(
    TodoDeletedEvent event,
  ) async* {
    final todoId = event.todo.id;

    yield TodoListTodoDeletingState(
      state.todosStatistics
        ..removeWhere((todoStatistics) => todoStatistics.todo.id == todoId),
      state.viewSettings,
    );

    await _todosInteractor.makeTodoRestorable(todoId);
    final deletedTodoData = TodoData(
      branchId: branchId ?? (await _todosInteractor.getBranchOfTodo(todoId)).id,
      todo: await _todosInteractor.getTodo(todoId),
      todoSteps: await _todosInteractor.getStepsOfTodo(todoId),
      todoImages: await _todosInteractor.getImagesOfTodo(todoId),
    );

    await _todosInteractor.deleteTodo(todoId, isRestorable: true);
    _allTodos = await _todosInteractor.getTodos(branchId: branchId);

    yield TodoListTodoDeletedState(
      deletedTodoData,
      await _mapTodosToView(),
      state.viewSettings,
    );
  }

  /// Изменяет задачу.
  Stream<TodoListState> _mapTodoEditedEventToState(
    TodoEditedEvent event,
  ) async* {
    await _todosInteractor.editTodo(event.todo);
    _allTodos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodoListContentState(await _mapTodosToView(), state.viewSettings);
  }

  /// Добавляет задачу.
  Stream<TodoListState> _mapTodoAddedEventToState(
    TodoAddedEvent event,
  ) async* {
    await _todosInteractor.addTodo(branchId, event.todo);
    _allTodos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodoListContentState(await _mapTodosToView(), state.viewSettings);
  }

  /// Возвращает удаленную задачу.
  Stream<TodoListState> _mapTodoRestoredEventToState(
    TodoRestoredEvent event,
  ) async* {
    final todoData = event.todoData;
    await _todosInteractor.addTodo(todoData.branchId, todoData.todo);
    for (final step in todoData.todoSteps) {
      await _todosInteractor.addTodoStep(todoData.todo.id, step);
    }
    for (final image in todoData.todoImages) {
      await _todosInteractor.addTodoImage(todoData.todo.id, image);
    }

    _allTodos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodoListContentState(await _mapTodosToView(), state.viewSettings);
  }

  /// Удаляет выполненные задачи.
  Stream<TodoListState> _mapCompletedTodosDeletedEventToState(
    CompletedTodosDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteCompletedTodos(branchId: branchId);
    _allTodos = await _todosInteractor.getTodos(branchId: branchId);
    yield TodoListContentState(await _mapTodosToView(), state.viewSettings);
  }

  /// Сохраняет и применяет новые настройки отображения.
  Stream<TodoListState> _mapViewSettingsChangedEventToState(
    ViewSettingsChangedEvent event,
  ) async* {
    await _settingsInteractor.saveTodosViewSettings(event.viewSettings);
    yield TodoListContentState(
      await _mapTodosToView(event.viewSettings),
      event.viewSettings,
    );
  }

  /// Загружает статистику каждой задачи.
  Future<List<TodoStatistics>> _loadStatistics(List<Todo> todos) async {
    final futureTodos = todos.map((todo) async {
      final steps = await _todosInteractor.getStepsOfTodo(todo.id);
      final completedStepsCount =
          steps.where((step) => step.wasCompleted).length;
      return TodoStatistics(todo, steps.length, completedStepsCount);
    });

    return Future.wait(futureTodos);
  }

  /// Создает новый список на основе [_allTodos], применяет к нему настройки
  /// отображения [viewSettings] и загружает статистику каждой задачи.
  ///
  /// Если [viewSettings] не задано, берет настройки из
  /// [TodoListState.viewSettings].
  Future<List<TodoStatistics>> _mapTodosToView([
    TodosViewSettings viewSettings,
  ]) async {
    viewSettings ??= state.viewSettings;
    final todosWithAppliedSettings =
        _todosInteractor.applyTodosViewSettings(_allTodos, viewSettings);
    return await _loadStatistics(todosWithAppliedSettings);
  }
}
