/// Статистическая информация о задачах.
class TodosStatistics {
  /// Количество задач.
  final int todosCount;

  /// Количество выполненных задач.
  final int completedTodosCount;

  /// Количество невыполненных задач.
  int get uncompletedTodosCount => todosCount - completedTodosCount;

  /// Отношение числа выполненных задач к общему числу задач.
  double get completionProgress =>
      todosCount == 0 ? 0.0 : completedTodosCount / todosCount;

  const TodosStatistics(this.todosCount, this.completedTodosCount);
}
