part of 'todos_list_bloc.dart';

@immutable
abstract class TodosListEvent {}

/// Событие окончания загрузки списка задач.
class TodosListLoadedEvent extends TodosListEvent {
  /// Загруженный список задач.
  final List<Todo> todos;

  TodosListLoadedEvent(this.todos);
}

/// Событие удаления задачи.
class TodoDeletedEvent extends TodosListEvent {
  /// Идентификатор удаленной задачи.
  final String todoId;

  TodoDeletedEvent(this.todoId);
}

/// Событие изменения задачи.
class TodoEditedEvent extends TodosListEvent {
  /// Измененная задача.
  final Todo todo;

  TodoEditedEvent(this.todo);
}

/// Событие добавления задачи.
class TodoAddedEvent extends TodosListEvent {
  /// Добавленная задача.
  final Todo todo;

  TodoAddedEvent(this.todo);
}
