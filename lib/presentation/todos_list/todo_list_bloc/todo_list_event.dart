part of 'todo_list_bloc.dart';

@immutable
abstract class TodoListEvent {}

/// Событие запроса загрузки списка задач.
class TodosListLoadingRequestedEvent extends TodoListEvent {}

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

/// Событие скрытия или показа выполненных задач.
class CompletedTodosVisibilityChangedEvent extends TodoListEvent {
  /// Флаг, сигнализирующий о том, убраны ли из списка выполненные задачи.
  final bool areCompletedTodosVisible;

  CompletedTodosVisibilityChangedEvent(this.areCompletedTodosVisible);
}

/// Событие скрытия или показа не избранных задач.
class NonFavoriteTodosVisibilityChangedEvent extends TodoListEvent {
  /// Флаг, сигнализирующий о том, убраны ли из списка не избранные задачи.
  final bool areNonFavoriteTodosVisible;

  NonFavoriteTodosVisibilityChangedEvent(this.areNonFavoriteTodosVisible);
}

/// Событие удаления выполненных задач.
class CompletedTodosDeletedEvent extends TodoListEvent {}

/// Событие изменения порядка сортировки задач.
class TodosSortOrderChangedEvent extends TodoListEvent {
  /// Порядок сортировки задач.
  final TodosSortOrder sortOrder;

  TodosSortOrderChangedEvent(this.sortOrder);
}
