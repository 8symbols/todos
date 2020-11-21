part of 'todo_steps_bloc.dart';

@immutable
abstract class TodoStepsState {
  /// Список пунктов задачи.
  ///
  /// Может быть равен null.
  final List<TodoStep> steps;

  TodoStepsState(this.steps);
}

/// Состояние загрузки пунктов задачи.
class StepsLoadingState extends TodoStepsState {
  /// Создает состояние и устанавливает null в [steps].
  StepsLoadingState() : super(null);
}

/// Состояние работы со списком пунктов.
class StepsContentState extends TodoStepsState {
  /// Создает состояние с пунктами [steps].
  StepsContentState(List<TodoStep> steps) : super(steps);
}
