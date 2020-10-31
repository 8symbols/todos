part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListEvent {}

/// Событие окончания загрузки списка задач.
class TodosListLoadedEvent extends TodoListEvent {
  /// Загруженный список задач.
  final List<Todo> todos;

  TodosListLoadedEvent(this.todos);
}

/// Событие удаления задачи.
class TodoDeletedEvent extends TodoListEvent {
  /// Идентификатор удаленной задачи.
  final String todoId;

  TodoDeletedEvent(this.todoId);
}

/// Событие изменения задачи.
class TodoEditedEvent extends TodoListEvent {
  /// Измененная задача.
  final Todo todo;

  TodoEditedEvent(this.todo);
}

/// Событие добавления задачи.
class TodoAddedEvent extends TodoListEvent {
  /// Добавленная задача.
  final Todo todo;

  TodoAddedEvent(this.todo);
}
