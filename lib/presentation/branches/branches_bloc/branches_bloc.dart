import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/branches/models/branch_statistics.dart';
import 'package:todos/presentation/branches/models/todos_statistics.dart';

part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  /// Интерактор для работы с ветками.
  final TodosInteractor _todosInteractor;

  BranchesBloc(ITodosRepository todosRepository)
      : _todosInteractor =
            TodosInteractor(todosRepository, NotificationsService()),
        super(const BranchesLoadingState());

  @override
  Stream<BranchesState> mapEventToState(
    BranchesEvent event,
  ) async* {
    if (event is BranchesLoadingRequestedEvent) {
      yield* _mapBranchesLoadingRequestedEventToState(event);
    } else if (event is BranchAddedEvent) {
      yield* _mapBranchAddedEventToState(event);
    } else if (event is BranchDeletedEvent) {
      yield* _mapBranchDeletedEventToState(event);
    }
  }

  /// Загружает ветки.
  Stream<BranchesState> _mapBranchesLoadingRequestedEventToState(
    BranchesLoadingRequestedEvent event,
  ) async* {
    yield await _loadBranchesWithStatistics();
  }

  /// Добавляет ветку.
  Stream<BranchesState> _mapBranchAddedEventToState(
    BranchAddedEvent event,
  ) async* {
    await _todosInteractor.addBranch(event.branch);
    yield await _loadBranchesWithStatistics();
  }

  /// Удаляет ветку.
  Stream<BranchesState> _mapBranchDeletedEventToState(
    BranchDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteBranch(event.branch.id);
    yield await _loadBranchesWithStatistics();
  }

  /// Загружает ветки и формирует статистику по ним.
  Future<BranchesState> _loadBranchesWithStatistics() async {
    final branches = await _todosInteractor.getBranches();
    final branchesStatistics = await _getBranchesStatistics(branches);
    final todosStatistics = _getTodosStatistics(branchesStatistics);
    return BranchesContentState(todosStatistics, branchesStatistics);
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
  TodosStatistics _getTodosStatistics(
    List<BranchStatistics> branchesStatistics,
  ) {
    final todosCount =
        branchesStatistics.fold(0, (sum, branch) => sum + branch.todosCount);
    final completedTodosCount = branchesStatistics.fold(
        0, (sum, branch) => sum + branch.completedTodosCount);
    return TodosStatistics(todosCount, completedTodosCount);
  }
}
