part of 'todo_steps_bloc.dart';

@immutable
abstract class TodoStepsState {
  /// Список пунктов задачи.
  ///
  /// Может быть равен null.
  final List<TodoStep> steps;

  const TodoStepsState(this.steps);
}

/// Состояние загрузки пунктов задачи.
class StepsLoadingState extends TodoStepsState {
  const StepsLoadingState() : super(null);
}

/// Состояние работы со списком пунктов.
class StepsContentState extends TodoStepsState {
  const StepsContentState(List<TodoStep> steps) : super(steps);
}

/// Состояние после добавления нового пункта.
class StepAddedState extends TodoStepsState {
  const StepAddedState(List<TodoStep> steps) : super(steps);
}
