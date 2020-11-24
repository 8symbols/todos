part of 'branch_cubit.dart';

@immutable
abstract class BranchState {
  /// Ветка задач.
  ///
  /// Может быть равной null.
  final Branch branch;

  const BranchState(this.branch);
}

/// Состояние работы с веткой.
class BranchContentState extends BranchState {
  const BranchContentState(Branch branch) : super(branch);
}

/// Состояние после изменения ветки.
class BranchEditedState extends BranchState {
  const BranchEditedState(Branch branch) : super(branch);
}
