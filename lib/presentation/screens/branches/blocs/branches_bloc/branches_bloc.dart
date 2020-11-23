import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/screens/branches/models/branch_statistics.dart';
import 'package:todos/presentation/screens/branches/models/todos_statistics.dart';

part 'branches_event.dart';
part 'branches_state.dart';

/// BloC для управления списком веток.
class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  /// Интерактор для работы с ветками.
  final TodosInteractor _todosInteractor;

  /// Интерактор для работы с настройками.
  final SettingsInteractor _settingsInteractor;

  List<Branch> _allBranches;

  BranchesBloc(
    ITodosRepository todosRepository,
    ISettingsStorage settingsStorage, {
    INotificationsService notificationsService = const NotificationsService(),
  })  : _todosInteractor = TodosInteractor(
          todosRepository,
          notificationsService: notificationsService,
        ),
        _settingsInteractor = SettingsInteractor(settingsStorage),
        super(const BranchesLoadingState());

  @override
  Stream<BranchesState> mapEventToState(
    BranchesEvent event,
  ) async* {
    if (event is InitializationRequestedEvent) {
      yield* _mapInitializationRequestedEventToState(event);
    } else if (event is BranchAddedEvent) {
      yield* _mapBranchAddedEventToState(event);
    } else if (event is BranchDeletedEvent) {
      yield* _mapBranchDeletedEventToState(event);
    } else if (event is ViewSettingsChangedEvent) {
      yield* _mapViewSettingsChangedEventToState(event);
    }
  }

  /// Загружает ветки и настройки отображения.
  Stream<BranchesState> _mapInitializationRequestedEventToState(
    InitializationRequestedEvent event,
  ) async* {
    _allBranches = await _todosInteractor.getBranches();
    final viewSettings = await _settingsInteractor.getBranchesViewSettings();
    final branchesStatistics = await _mapBranchesToView(viewSettings);

    yield BranchesContentState(
      _getAllTodosStatistics(branchesStatistics),
      branchesStatistics,
      viewSettings,
    );
  }

  /// Добавляет ветку.
  Stream<BranchesState> _mapBranchAddedEventToState(
    BranchAddedEvent event,
  ) async* {
    await _todosInteractor.addBranch(event.branch);
    _allBranches = await _todosInteractor.getBranches();
    final branchesStatistics = await _mapBranchesToView();

    yield BranchesContentState(
      _getAllTodosStatistics(branchesStatistics),
      branchesStatistics,
      state.viewSettings,
    );
  }

  /// Удаляет ветку.
  Stream<BranchesState> _mapBranchDeletedEventToState(
    BranchDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteBranch(event.branch.id);
    _allBranches = await _todosInteractor.getBranches();
    final branchesStatistics = await _mapBranchesToView();

    yield BranchesContentState(
      _getAllTodosStatistics(branchesStatistics),
      branchesStatistics,
      state.viewSettings,
    );
  }

  /// Сохраняет и применяет новые настройки отображения.
  Stream<BranchesState> _mapViewSettingsChangedEventToState(
    ViewSettingsChangedEvent event,
  ) async* {
    await _settingsInteractor.saveBranchesViewSettings(event.viewSettings);
    final branchesStatistics = await _mapBranchesToView(event.viewSettings);

    yield BranchesContentState(
      _getAllTodosStatistics(branchesStatistics),
      branchesStatistics,
      event.viewSettings,
    );
  }

  /// Загружает статистику по каждой ветке из [branches].
  Future<List<BranchStatistics>> _getBranchesStatistics(
    List<Branch> branches,
  ) {
    final futureBranchesStatistics = branches.map((branch) async {
      final todos = await _todosInteractor.getTodos(branchId: branch.id);
      final completedTodosCount =
          todos.where((todo) => todo.wasCompleted).length;
      return BranchStatistics(branch, todos.length, completedTodosCount);
    });

    return Future.wait(futureBranchesStatistics);
  }

  /// Формирует общую статистику на основе статистик веток
  /// [branchesStatistics].
  TodosStatistics _getAllTodosStatistics(
    List<BranchStatistics> branchesStatistics,
  ) {
    final todosCount =
        branchesStatistics.fold(0, (sum, branch) => sum + branch.todosCount);
    final completedTodosCount = branchesStatistics.fold(
        0, (sum, branch) => sum + branch.completedTodosCount);
    return TodosStatistics(todosCount, completedTodosCount);
  }

  /// Создает список веток на основе [_allBranches], применяет к нему настройки
  /// отображения [viewSettings] и формирует статистику.
  ///
  /// Если [viewSettings] не задан, использует [BranchesState.viewSettings].
  Future<List<BranchStatistics>> _mapBranchesToView([
    BranchesViewSettings viewSettings,
  ]) async {
    viewSettings ??= state.viewSettings;
    final branches =
        _todosInteractor.applyBranchesViewSettings(_allBranches, viewSettings);
    return await _getBranchesStatistics(branches);
  }
}
