part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  /// Задача.
  ///
  /// Может быть равна null.
  final Todo todo;

  const TodoState(this.todo);
}

/// Состояние использования задачи.
class TodoContentState extends TodoState {
  const TodoContentState(Todo todo) : super(todo);
}

/// Состояние после изменения задачи.
class TodoEditedState extends TodoState {
  const TodoEditedState(Todo todo) : super(todo);
}

/// Состояние после удаления задачи.
class TodoDeletedState extends TodoState {
  const TodoDeletedState() : super(null);
}
