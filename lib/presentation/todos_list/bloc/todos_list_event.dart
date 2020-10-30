part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListEvent {}

class TodosListLoadedEvent extends TodosListEvent {
  final List<Todo> todos;

  TodosListLoadedEvent(this.todos);
}

class TodoDeletedEvent extends TodosListEvent {
  final String todoId;

  TodoDeletedEvent(this.todoId);
}

class TodoEditedEvent extends TodosListEvent {
  final String todoId;

  final Todo todo;

  TodoEditedEvent(this.todoId, this.todo);
}

class TodoAddedEvent extends TodosListEvent {
  final Todo todo;

  TodoAddedEvent(this.todo);
}
