import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';

typedef void TodoEditedCallback(Todo editedTodo);

/// Виджет для отображения задачи в списке задач.
class TodoCard extends StatelessWidget {
  /// Задача.
  final Todo todo;

  /// Callback, вызывающийся при удалении задачи.
  final VoidCallback onDelete;

  /// Callback, вызывающийся при изменении задачи.
  final TodoEditedCallback onEdit;

  TodoCard(this.todo, {@required this.onDelete, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(todo.id),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: todo.wasCompleted,
              onChanged: (newValue) =>
                  onEdit(todo.copyWith(wasCompleted: newValue)),
            ),
            Expanded(child: Text(todo.title)),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
