part of 'branches_bloc.dart';

@immutable
abstract class BranchesEvent {
  const BranchesEvent();
}

/// Событие запроса загрузки настроек отображения списка веток
/// и самого списка веток.
class InitializationRequestedEvent extends BranchesEvent {
  const InitializationRequestedEvent();
}

/// Запрос обновления списка веток.
class BranchesOutdatedEvent extends BranchesEvent {
  const BranchesOutdatedEvent();
}

/// Изменились настройки отображения.
class ViewSettingsChangedEvent extends BranchesEvent {
  /// Новые настройки отображения.
  final BranchesViewSettings viewSettings;

  const ViewSettingsChangedEvent(this.viewSettings);
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
