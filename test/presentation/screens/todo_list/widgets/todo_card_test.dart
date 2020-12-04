import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todo_list/models/todo_statistics.dart';
import 'package:todos/presentation/screens/todo_list/widgets/todo_card.dart';

void main() {
  group('TodoCard', () {
    testWidgets('отображает название задачи', (WidgetTester tester) async {
      final statistics = TodoStatistics(Todo('a'), 0, 0);
      await tester.pumpWidget(
        MaterialApp(
          home: TodoCard(
            statistics,
            onDelete: null,
            onEdit: null,
            onTap: null,
          ),
        ),
      );

      expect(find.text(statistics.todo.title), findsOneWidget);
    });

    testWidgets('отображает шаги, если они есть', (WidgetTester tester) async {
      final statisticsWithoutSteps = TodoStatistics(Todo('a'), 0, 0);
      final statisticsWithSteps = TodoStatistics(Todo('a'), 5, 3);

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              TodoCard(
                statisticsWithoutSteps,
                onDelete: null,
                onEdit: null,
                onTap: null,
              ),
              TodoCard(
                statisticsWithSteps,
                onDelete: null,
                onEdit: null,
                onTap: null,
              ),
            ],
          ),
        ),
      );

      final withoutStepsText = '0 из 0';
      final withStepsText = '${statisticsWithSteps.completedStepsCount} '
          'из ${statisticsWithSteps.stepsCount}';

      expect(find.text(withoutStepsText), findsNothing);
      expect(find.text(withStepsText), findsOneWidget);
    });

    testWidgets('отображает дедлайн', (WidgetTester tester) async {
      final deadline = DateTime.now();

      final statistics =
          TodoStatistics(Todo('a', deadlineTime: deadline), 0, 0);

      await tester.pumpWidget(
        MaterialApp(
          home: TodoCard(
            statistics,
            onDelete: null,
            onEdit: null,
            onTap: null,
          ),
        ),
      );

      expect(
        find.text('До ${TodoCard.deadlineDateFormat.format(deadline)}'),
        findsOneWidget,
      );
    });

    testWidgets('отображает шаги и дедлайн', (WidgetTester tester) async {
      final deadline = DateTime.now();

      final statistics =
          TodoStatistics(Todo('a', deadlineTime: deadline), 1, 0);

      await tester.pumpWidget(
        MaterialApp(
          home: TodoCard(
            statistics,
            onDelete: null,
            onEdit: null,
            onTap: null,
          ),
        ),
      );

      final stepsText = '${statistics.completedStepsCount} '
          'из ${statistics.stepsCount}';

      expect(find.text(stepsText), findsOneWidget);
      expect(
        find.text('До ${TodoCard.deadlineDateFormat.format(deadline)}'),
        findsOneWidget,
      );
    });

    testWidgets('отображает чекбокс выполнения', (WidgetTester tester) async {
      final statistics = TodoStatistics(Todo('a'), 0, 0);
      final completedStatistics =
          TodoStatistics(Todo('b', wasCompleted: true), 0, 0);

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              TodoCard(
                statistics,
                onDelete: null,
                onEdit: null,
                onTap: null,
              ),
              TodoCard(
                completedStatistics,
                onDelete: null,
                onEdit: null,
                onTap: null,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(CircularCheckBox), findsNWidgets(2));

      expect(
        find.byWidgetPredicate(
          (widget) => widget is CircularCheckBox && widget.value,
        ),
        findsOneWidget,
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is CircularCheckBox && !widget.value,
        ),
        findsOneWidget,
      );
    });
  });
}
