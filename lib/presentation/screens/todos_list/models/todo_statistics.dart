import 'package:todos/domain/models/todo.dart';

/// Статистика задачи.
class TodoStatistics {
  /// Задача.
  final Todo todo;

  /// Количество пунктов в задаче.
  final int stepsCount;

  /// Количество выполненных пунктов в задаче.
  final int completedStepsCount;

  const TodoStatistics(this.todo, this.stepsCount, this.completedStepsCount);
}
