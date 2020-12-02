import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/branches/models/branch_statistics.dart';
import 'package:todos/presentation/screens/branches/widgets/branch_card.dart';
import 'package:todos/presentation/screens/branches/widgets/branches_grid.dart';

class MockDeletionModeCubit extends MockBloc<bool>
    implements DeletionModeCubit {}

void main() {
  group('BranchesGrid', () {
    testWidgets('отображает ветки', (WidgetTester tester) async {
      final branchesStatistics = [
        BranchStatistics(Branch('a', BranchThemes.defaultBranchTheme), 5, 3),
        BranchStatistics(Branch('b', BranchThemes.defaultBranchTheme), 0, 0),
        BranchStatistics(Branch('c', BranchThemes.defaultBranchTheme), 1, 0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DeletionModeCubit>(
            create: (context) {
              final cubit = MockDeletionModeCubit();
              when(cubit.state).thenReturn(false);
              return cubit;
            },
            child: CustomScrollView(
              slivers: [
                BranchesGrid(
                  branchesStatistics,
                  onBranchTap: null,
                  onAddBranch: null,
                  onBranchDeleted: null,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(BranchCard), findsNWidgets(branchesStatistics.length));

      for (final statistics in branchesStatistics) {
        expect(find.text(statistics.branch.title), findsOneWidget);
      }
    });
  });
}
