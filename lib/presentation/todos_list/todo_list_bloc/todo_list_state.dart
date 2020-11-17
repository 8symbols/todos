part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {
  /// Список задач.
  ///
  /// Может быть равен null.
  final List<TodoViewData> todos;

  /// Флаг, сигнализирующий о том, убраны ли из списка выполненные задачи.
  final bool areCompletedTodosVisible;

  /// Флаг, сигнализирующий о том, убраны ли из списка не избранные задачи.
  final bool areNonFavoriteTodosVisible;

  TodoListState(
    this.todos,
    this.areCompletedTodosVisible,
    this.areNonFavoriteTodosVisible,
  );
}

/// Состояние загрузки списка задач.
class TodosListLoadingState extends TodoListState {
  /// Создает состояние и устанавливает null в [todos].
  TodosListLoadingState(
    bool areCompletedTodosVisible,
    bool areNonFavoriteTodosVisible,
  ) : super(null, areCompletedTodosVisible, areNonFavoriteTodosVisible);
}

/// Состояние работы со списком задач.
class TodosListContentState extends TodoListState {
  /// Создает состояние со списком задач [todos].
  TodosListContentState(
    List<TodoViewData> todos,
    areCompletedTodosVisible,
    bool areNonFavoriteTodosVisible,
  ) : super(todos, areCompletedTodosVisible, areNonFavoriteTodosVisible);
}

/// Состояние работы со списком задач после удаления задачи.
class TodosListDeletedTodoState extends TodoListState {
  /// Удаленная задача
  final Todo todo;

  /// Создает состояние со списком задач [todos].
  TodosListDeletedTodoState(
    this.todo,
    List<TodoViewData> todos,
    areCompletedTodosVisible,
    bool areNonFavoriteTodosVisible,
  ) : super(todos, areCompletedTodosVisible, areNonFavoriteTodosVisible);
}
