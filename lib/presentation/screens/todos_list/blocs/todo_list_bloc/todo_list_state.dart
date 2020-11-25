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
  const TodoListLoadingState() : super(null, null);
}

/// Состояние работы со списком задач.
class TodoListContentState extends TodoListState {
  const TodoListContentState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние во время удаления задачи.
///
/// Удаляемая задача не содержится в [TodoListState.todosStatistics].
class TodoListTodoDeletingState extends TodoListState {
  const TodoListTodoDeletingState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние после удаления задачи.
class TodoListTodoDeletedState extends TodoListState {
  /// Информация о удаленной задаче.
  final TodoData todoData;

  const TodoListTodoDeletedState(
    this.todoData,
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние после удаления нескольких задач.
class TodoListTodosDeletedState extends TodoListState {
  const TodoListTodosDeletedState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние после добавления задачи.
class TodoListTodoAddedState extends TodoListState {
  const TodoListTodoAddedState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}

/// Состояние после изменения задачи.
class TodoListTodoEditedState extends TodoListState {
  const TodoListTodoEditedState(
    List<TodoStatistics> todosStatistics,
    TodosViewSettings viewSettings,
  ) : super(todosStatistics, viewSettings);
}
