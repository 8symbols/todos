import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/todos_list/todo_card.dart';

/// Виджет для отображения списка задач.
class TodoList extends StatelessWidget {
  /// Список задач.
  final List<Todo> todos;

  TodoList(this.todos);

  @override
  Widget build(BuildContext context) {
    const emptySpaceForFabHeight = 88.0;

    return todos.isEmpty
        ? const Center(child: Text('Нет элементов'))
        : ListView(
            children: [
              ...todos.map((e) => TodoCard(e)).toList(),
              const SizedBox(height: emptySpaceForFabHeight),
            ],
          );
  }
}
