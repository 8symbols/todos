part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  /// Задача.
  ///
  /// Может быть равна null.
  final Todo todo;

  TodoState(this.todo);
}

/// Состояние использования задачи.
class TodoContentState extends TodoState {
  TodoContentState(Todo todo) : super(todo);
}

/// Состояние удаленной задачи.
class TodoDeletedState extends TodoState {
  TodoDeletedState() : super(null);
}
