part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListEvent {}

/// Событие запроса загрузки настроек отображения списка задач
/// и самого списка задач.
class InitializationRequestedEvent extends TodoListEvent {}

/// Событие удаления задачи.
class TodoDeletedEvent extends TodoListEvent {
  /// Удаленная задача.
  final Todo todo;

  TodoDeletedEvent(this.todo);
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

/// Событие удаления выполненных задач.
class CompletedTodosDeletedEvent extends TodoListEvent {}

/// Событие изменения настроек отображения.
class TodoListViewSettingsChangedEvent extends TodoListEvent {
  /// Настройки отображения.
  final TodoListViewSettings viewSettings;

  TodoListViewSettingsChangedEvent(this.viewSettings);
}
