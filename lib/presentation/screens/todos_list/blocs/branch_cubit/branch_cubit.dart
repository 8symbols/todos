import 'package:bloc/bloc.dart';
import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

/// Cubit для работы с веткой задач.
///
/// Ветка может быть равна [null].
class BranchCubit extends Cubit<Branch> {
  /// Интерактор для взаимодействия с веткой.
  final TodosInteractor _todosInteractor;

  BranchCubit(
    ITodosRepository todosRepository, {
    Branch branch,
    INotificationsService notificationsService = const NotificationsService(),
  })  : _todosInteractor = TodosInteractor(
          todosRepository,
          notificationsService: notificationsService,
        ),
        super(branch);

  /// Редактирует ветку.
  void editBranch(Branch editedBranch) async {
    await _todosInteractor.editBranch(editedBranch);
    emit(editedBranch);
  }
}
