part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListEvent {
  const TodoListEvent();
}

/// Событие запроса загрузки настроек отображения списка задач
/// и самого списка задач.
class InitializationRequestedEvent extends TodoListEvent {
  const InitializationRequestedEvent();
}

/// Запрос обновления списка задач.
class TodoListOutdatedEvent extends TodoListEvent {
  const TodoListOutdatedEvent();
}

/// Событие удаления задачи.
class TodoDeletedEvent extends TodoListEvent {
  /// Удаленная задача.
  final Todo todo;

  const TodoDeletedEvent(this.todo);
}

/// Событие изменения задачи.
class TodoEditedEvent extends TodoListEvent {
  /// Измененная задача.
  final Todo todo;

  const TodoEditedEvent(this.todo);
}

/// Событие добавления задачи.
class TodoAddedEvent extends TodoListEvent {
  /// Добавленная задача.
  final Todo todo;

  const TodoAddedEvent(this.todo);
}

/// Событие отмены удаления задачи.
class TodoRestoredEvent extends TodoListEvent {
  /// Ветка удаленной задачи.
  final String branchId;

  /// Удаленная задача.
  final Todo todo;

  const TodoRestoredEvent(this.branchId, this.todo);
}

/// Событие удаления выполненных задач.
class CompletedTodosDeletedEvent extends TodoListEvent {
  const CompletedTodosDeletedEvent();
}

/// Событие изменения настроек отображения.
class ViewSettingsChangedEvent extends TodoListEvent {
  /// Настройки отображения.
  final TodosViewSettings viewSettings;

  const ViewSettingsChangedEvent(this.viewSettings);
}
