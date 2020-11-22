part of 'branches_bloc.dart';

@immutable
abstract class BranchesState {
  /// Статистика по всем задачам.
  ///
  /// Может быть равным  null.
  final TodosStatistics todosStatistics;

  /// Статистика по веткам.
  ///
  /// Может быть равным  null.
  final List<BranchStatistics> branchesStatistics;

  const BranchesState(this.todosStatistics, this.branchesStatistics);
}

/// Состояние загрузки веток.
class BranchesLoadingState extends BranchesState {
  const BranchesLoadingState() : super(null, null);
}

/// Состояние работы с ветками.
class BranchesContentState extends BranchesState {
  const BranchesContentState(
    TodosStatistics todosStatistics,
    List<BranchStatistics> branchesStatistics,
  ) : super(todosStatistics, branchesStatistics);
}
