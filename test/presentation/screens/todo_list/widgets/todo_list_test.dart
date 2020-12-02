import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todo_list/models/todo_statistics.dart';
import 'package:todos/presentation/screens/todo_list/widgets/empty_todo_list.dart';
import 'package:todos/presentation/screens/todo_list/widgets/todo_card.dart';
import 'package:todos/presentation/screens/todo_list/widgets/todo_list.dart';

void main() {
  group('TodoList', () {
    testWidgets('отображает задачи', (WidgetTester tester) async {
      final pastDeadline = DateTime.now().subtract(Duration(hours: 1));
      final futureDeadline = DateTime.now().add(Duration(hours: 1));

      final todosStatistics = [
        TodoStatistics(Todo('a'), 0, 0),
        TodoStatistics(Todo('b'), 0, 1),
        TodoStatistics(Todo('c'), 1, 1),
        TodoStatistics(Todo('d', deadlineTime: pastDeadline), 0, 0),
        TodoStatistics(Todo('e', deadlineTime: futureDeadline), 0, 0),
        TodoStatistics(Todo('f', deadlineTime: futureDeadline), 0, 1),
      ];

      await tester.pumpWidget(MaterialApp(home: TodoList(todosStatistics)));

      expect(find.byType(TodoCard), findsNWidgets(todosStatistics.length));

      for (final statistics in todosStatistics) {
        expect(find.text(statistics.todo.title), findsOneWidget);
      }
    });

    testWidgets('отображает пустой список', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TodoList([])));
      expect(find.byType(EmptyTodoList), findsOneWidget);
    });
  });
}
