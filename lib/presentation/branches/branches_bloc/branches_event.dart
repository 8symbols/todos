part of 'branches_bloc.dart';

@immutable
abstract class BranchesEvent {
  const BranchesEvent();
}

/// Запрос загрузки веток.
class BranchesLoadingRequestedEvent extends BranchesEvent {
  const BranchesLoadingRequestedEvent();
}

/// Событие добавления ветки.
class BranchAddedEvent extends BranchesEvent {
  /// Новая ветка.
  final Branch branch;

  const BranchAddedEvent(this.branch);
}

/// Событие удаления ветки.
class BranchDeletedEvent extends BranchesEvent {
  /// Удаленная ветка.
  final Branch branch;

  const BranchDeletedEvent(this.branch);
}
