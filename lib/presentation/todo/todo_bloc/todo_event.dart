part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

/// Событие удаления задачи.
class TodoDeletedEvent extends TodoEvent {}

/// Событие изменения задачи.
class TodoEditedEvent extends TodoEvent {
  /// Измененная задача.
  final Todo todo;

  TodoEditedEvent(this.todo);
}
