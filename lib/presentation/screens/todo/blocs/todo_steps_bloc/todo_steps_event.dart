part of 'todo_steps_bloc.dart';

@immutable
abstract class TodoStepsEvent {
  const TodoStepsEvent();
}

/// Событие запроса загрузки пунктов задачи.
class StepsLoadingRequestedEvent extends TodoStepsEvent {
  const StepsLoadingRequestedEvent();
}

/// Событие удаления пункта.
class StepDeletedEvent extends TodoStepsEvent {
  /// Идентификатор удаленного пункта.
  final String stepId;

  const StepDeletedEvent(this.stepId);
}

/// Событие удаления выполненных шагов.
class CompletedStepsDeletedEvent extends TodoStepsEvent {
  const CompletedStepsDeletedEvent();
}

/// Событие изменения пункта задачи.
class StepEditedEvent extends TodoStepsEvent {
  /// Измененный пункт.
  final TodoStep step;

  const StepEditedEvent(this.step);
}

/// Событие добавления пункта.
class StepAddedEvent extends TodoStepsEvent {
  /// Добавленный пункт.
  final TodoStep step;

  const StepAddedEvent(this.step);
}
