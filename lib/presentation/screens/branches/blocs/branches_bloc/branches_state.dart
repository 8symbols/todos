part of 'branches_bloc.dart';

@immutable
abstract class BranchesState {
  /// Статистика по всем задачам.
  ///
  /// Может быть равным null.
  final TodosStatistics todosStatistics;

  /// Статистика по веткам.
  ///
  /// Может быть равным null.
  final List<BranchStatistics> branchesStatistics;

  /// Настройка отображения.
  ///
  /// Может быть равным null.
  final BranchesViewSettings viewSettings;

  const BranchesState(
    this.todosStatistics,
    this.branchesStatistics,
    this.viewSettings,
  );
}

/// Состояние загрузки веток.
class BranchesLoadingState extends BranchesState {
  const BranchesLoadingState() : super(null, null, null);
}

/// Состояние работы с ветками.
class BranchesContentState extends BranchesState {
  const BranchesContentState(
    TodosStatistics todosStatistics,
    List<BranchStatistics> branchesStatistics,
    BranchesViewSettings viewSettings,
  ) : super(todosStatistics, branchesStatistics, viewSettings);
}

/// Состояние после удаления ветки.
class BranchDeletedState extends BranchesState {
  const BranchDeletedState(
    TodosStatistics todosStatistics,
    List<BranchStatistics> branchesStatistics,
    BranchesViewSettings viewSettings,
  ) : super(todosStatistics, branchesStatistics, viewSettings);
}

/// Состояние после добавления ветки.
class BranchAddedState extends BranchesState {
  const BranchAddedState(
    TodosStatistics todosStatistics,
    List<BranchStatistics> branchesStatistics,
    BranchesViewSettings viewSettings,
  ) : super(todosStatistics, branchesStatistics, viewSettings);
}
