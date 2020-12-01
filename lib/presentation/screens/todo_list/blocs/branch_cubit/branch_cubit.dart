import 'package:bloc/bloc.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';

/// Cubit для работы с веткой задач.
///
/// Ветка может быть равна [null].
class BranchCubit extends Cubit<Branch> {
  /// Интерактор для взаимодействия с веткой.
  final TodosInteractor _todosInteractor;

  BranchCubit(this._todosInteractor, {Branch branch}) : super(branch);

  /// Редактирует ветку.
  void editBranch(Branch editedBranch) async {
    await _todosInteractor.editBranch(editedBranch);
    emit(editedBranch);
  }
}
