part of 'todo_steps_bloc.dart';

@immutable
abstract class TodoStepsEvent {}

/// Событие запроса загрузки пунктов задачи.
class StepsLoadingRequestedEvent extends TodoStepsEvent {}

/// Событие удаления пункта.
class StepDeletedEvent extends TodoStepsEvent {
  /// Идентификатор удаленного пункта.
  final String stepId;

  StepDeletedEvent(this.stepId);
}

/// Событие изменения пункта задачи.
class StepEditedEvent extends TodoStepsEvent {
  /// Измененный пункт.
  final TodoStep step;

  StepEditedEvent(this.step);
}

/// Событие добавления пункта.
class StepAddedEvent extends TodoStepsEvent {
  /// Добавленный пункт.
  final TodoStep step;

  StepAddedEvent(this.step);
}
