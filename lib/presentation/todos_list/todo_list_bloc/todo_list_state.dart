part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {
  /// Список задач.
  ///
  /// Равен null до инициализации.
  final List<TodoViewData> todos;

  /// Настройки отображения.
  ///
  /// Равены null до инициализации.
  final TodoListViewSettings viewSettings;

  const TodoListState(this.todos, this.viewSettings);
}

/// Состояние загрузки списка задач.
class TodoListLoadingState extends TodoListState {
  TodoListLoadingState() : super(null, null);
}

/// Состояние работы со списком задач.
class TodoListContentState extends TodoListState {
  TodoListContentState(
    List<TodoViewData> todos,
    TodoListViewSettings viewSettings,
  ) : super(todos, viewSettings);
}

/// Состояние работы со списком задач после удаления задачи.
class TodoListDeletedTodoState extends TodoListState {
  /// Удаленная задача
  final Todo todo;

  TodoListDeletedTodoState(
    this.todo,
    List<TodoViewData> todos,
    TodoListViewSettings viewSettings,
  ) : super(todos, viewSettings);
}
