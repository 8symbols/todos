import 'package:bloc/bloc.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

/// Cubit для работы с темой ветки.
class ThemeCubit extends Cubit<BranchTheme> {
  /// Ветка.
  ///
  /// Может быть равна null.
  Branch branch;

  /// Интерактор для взаимодействия с веткой.
  final TodosInteractor _todosInteractor;

  ThemeCubit(ITodosRepository todosRepository, {this.branch})
      : _todosInteractor = TodosInteractor(todosRepository),
        super(branch?.theme);

  /// Меняет тему ветки.
  void changeTheme(BranchTheme theme) async {
    branch = branch.copyWith(theme: theme);
    await _todosInteractor.editBranch(branch);
    emit(branch.theme);
  }
}
