import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/screens/branches/models/todos_statistics.dart';

/// Статистическая информация о задачах в пределах ветки.
class BranchStatistics extends TodosStatistics {
  /// Ветка задач.
  final Branch branch;

  const BranchStatistics(this.branch, int todosCount, int completedTodosCount)
      : super(todosCount, completedTodosCount);
}
