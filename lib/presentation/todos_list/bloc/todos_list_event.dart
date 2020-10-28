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
  final String todo;

  TodoEdited(this.todo);
}
