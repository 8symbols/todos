part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListState {
  /// Список задач.
  ///
  /// Может быть равен null.
  final List<TodoViewData> todos;

  TodoListState(this.todos);
}

/// Состояние загрузки списка задач.
class TodosListLoadingState extends TodoListState {
  /// Создает состояние и устанавливает null в [todos].
  TodosListLoadingState() : super(null);
}

/// Состояние работы со списком задач.
class TodosListUsingState extends TodoListState {
  /// Создает состояние со списком задач [todos].
  TodosListUsingState(List<TodoViewData> todos) : super(todos);
}
