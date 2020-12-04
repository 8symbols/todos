import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/todo_list/blocs/branch_cubit/branch_cubit.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('BranchCubit', () {
    TodosInteractor todosInteractor;

    setUp(() {
      todosInteractor = MockTodosInteractor();
    });

    blocTest<BranchCubit, Branch>(
      'не изменяет состояние, если не приходят события',
      build: () => BranchCubit(todosInteractor),
      expect: [],
    );

    blocTest<BranchCubit, Branch>(
      'изменяет ветку',
      build: () {
        when(todosInteractor.editBranch(any)).thenAnswer((_) async {});
        return BranchCubit(
          todosInteractor,
          branch: Branch('', BranchThemes.defaultBranchTheme),
        );
      },
      act: (cubit) =>
          cubit.editBranch(Branch('', BranchThemes.defaultBranchTheme)),
      expect: [isA<Branch>()],
      verify: (_) => verify(todosInteractor.editBranch(any)),
    );
  });
}
