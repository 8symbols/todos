part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListEvent {}

class TodosListLoaded extends TodosListEvent {
  final List<Todo> todos;

  TodosListLoaded(this.todos);
}

class TodoDeleted extends TodosListEvent {
  final String todoId;

  TodoDeleted(this.todoId);
}

class TodoEdited extends TodosListEvent {
  final String todoId;

  final Todo todo;

  TodoEdited(this.todoId, this.todo);
}

class TodoAdded extends TodosListEvent {
  final Todo todo;

  TodoAdded(this.todo);
}

class ShouldShowFabChanged extends TodosListEvent {
  final bool shouldShowFab;

  ShouldShowFabChanged(this.shouldShowFab);
}
