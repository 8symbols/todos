import 'package:todos/domain/models/todo.dart';

/// Модель данных о задаче для отображения в [TodoCard].
class TodoViewData {
  /// Задача.
  final Todo todo;

  /// Количество пунктов в задаче.
  final int stepsCount;

  /// Количество выполненных пунктов в задаче.
  final int completedStepsCount;

  const TodoViewData(this.todo, this.stepsCount, this.completedStepsCount);
}
