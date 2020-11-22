import 'package:bloc/bloc.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

/// Cubit для работы с веткой задач.
class BranchCubit extends Cubit<Branch> {
  /// Ветка.
  ///
  /// Может быть равна null.
  Branch branch;

  /// Интерактор для взаимодействия с веткой.
  final TodosInteractor _todosInteractor;

  BranchCubit(ITodosRepository todosRepository, {this.branch})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(branch);

  /// Редактирует ветку.
  void editBranch(Branch editedBranch) async {
    await _todosInteractor.editBranch(editedBranch);
    emit(editedBranch);
  }
}
