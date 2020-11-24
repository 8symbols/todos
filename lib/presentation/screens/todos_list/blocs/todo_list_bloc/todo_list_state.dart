part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {
  /// Список задач.
  ///
  /// Равен null до инициализации.
  final List<TodoStatistics> todosStatistics;

  /// Настройки отображения.
  ///
  /// Равены null до инициализации.
  final TodosViewSettings viewSettings;

  const TodoListState(this.todosStatistics, this.viewSettings);
}

/// Состояние загрузки списка задач.
class TodoListLoadingState extends TodoListState {
  TodoListLoadingState() : super(null, null);
}

/// Состояние работы со списком задач.
class TodoListContentState extends TodoListState {
  TodoListContentState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние во время удаления задачи.
///
/// Удаляемая задача не содержится в [TodoListState.todosStatistics].
class TodoDeletingState extends TodoListState {
  TodoDeletingState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние работы со списком задач после удаления задачи.
class TodoDeletedState extends TodoListState {
  /// Ветка удаленной задачи.
  final String branchId;

  /// Удаленная задача.
  final Todo todo;

  TodoDeletedState(
    this.branchId,
    this.todo,
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}
