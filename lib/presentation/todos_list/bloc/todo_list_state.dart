part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {
  /// Список задач.
  ///
  /// Может быть равен null.
  final List<TodoViewData> todos;

  /// Флаг, сигнализирующий о том, убраны ли из списка выполненные задачи.
  final bool areCompletedTodosVisible;

  TodoListState(this.todos, this.areCompletedTodosVisible);
}

/// Состояние загрузки списка задач.
class TodosListLoadingState extends TodoListState {
  /// Создает состояние и устанавливает null в [todos].
  TodosListLoadingState(bool areCompletedTodosVisible)
      : super(null, areCompletedTodosVisible);
}

/// Состояние работы со списком задач.
class TodosListUsingState extends TodoListState {
  /// Создает состояние со списком задач [todos].
  TodosListUsingState(List<TodoViewData> todos, areCompletedTodosVisible)
      : super(todos, areCompletedTodosVisible);
}
