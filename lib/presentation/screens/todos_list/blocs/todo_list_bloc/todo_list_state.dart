part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {
  /// Список задач.
  ///
  /// Равен null до инициализации.
  final List<TodoStatistics> todos;

  /// Настройки отображения.
  ///
  /// Равены null до инициализации.
  final TodosViewSettings viewSettings;

  const TodoListState(this.todos, this.viewSettings);
}

/// Состояние загрузки списка задач.
class TodoListLoadingState extends TodoListState {
  TodoListLoadingState() : super(null, null);
}

/// Состояние работы со списком задач.
class TodoListContentState extends TodoListState {
  TodoListContentState(
    List<TodoStatistics> todos,
    TodosViewSettings viewSettings,
  ) : super(todos, viewSettings);
}

/// Состояние работы со списком задач после удаления задачи.
class TodoListDeletedTodoState extends TodoListState {
  /// Ветка удаленной задачи.
  final String branchId;

  /// Удаленная задача.
  final Todo todo;

  TodoListDeletedTodoState(
    this.branchId,
    this.todo,
    List<TodoStatistics> todos,
    TodosViewSettings viewSettings,
  ) : super(todos, viewSettings);
}