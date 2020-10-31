part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListState {
  /// Список задач.
  ///
  /// Может быть равен null.
  final List<Todo> todos;

  TodosListState(this.todos);
}

/// Состояние загрузки списка задач.
class TodosListLoadingState extends TodosListState {
  /// Создает состояние и устанавливает null в [todos].
  TodosListLoadingState() : super(null);
}

/// Состояние работы со списком задач.
class TodosListUsingState extends TodosListState {
  /// Создает состояние со списком задач [todos].
  TodosListUsingState(List<Todo> todos) : super(todos);
}
