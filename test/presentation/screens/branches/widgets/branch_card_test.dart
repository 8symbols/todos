import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/branches/models/branch_statistics.dart';
import 'package:todos/presentation/screens/branches/widgets/branch_card.dart';

void main() {
  group('BranchCard', () {
    testWidgets('отображает название ветки', (WidgetTester tester) async {
      final statistics =
          BranchStatistics(Branch('a', BranchThemes.defaultBranchTheme), 0, 0);

      await tester.pumpWidget(
        MaterialApp(
          home: BranchCard(
            statistics,
            false,
            onTap: null,
            onDelete: null,
            onLongPress: null,
          ),
        ),
      );

      expect(find.text(statistics.branch.title), findsOneWidget);
    });

    testWidgets('отображает количество задач', (WidgetTester tester) async {
      final statistics =
          BranchStatistics(Branch('a', BranchThemes.defaultBranchTheme), 5, 3);

      await tester.pumpWidget(
        MaterialApp(
          home: BranchCard(
            statistics,
            false,
            onTap: null,
            onDelete: null,
            onLongPress: null,
          ),
        ),
      );

      final totalText = '${statistics.todosCount} задач(и)';
      final completedText = '${statistics.completedTodosCount} сделано';
      final uncompletedText = '${statistics.uncompletedTodosCount} осталось';

      expect(find.text(totalText), findsOneWidget);
      expect(find.text(completedText), findsOneWidget);
      expect(find.text(uncompletedText), findsOneWidget);
    });
  });
}
