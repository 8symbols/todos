import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/todos_list/bloc/todo_list_bloc.dart';

/// Виджет для отображения задачи в списке задач.
class TodoCard extends StatelessWidget {
  /// Задача.
  final Todo todo;

  TodoCard(this.todo);

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
              onChanged: (newValue) {
                final editedTodo = todo.copyWith(wasCompleted: newValue);
                context.bloc<TodoListBloc>().add(TodoEditedEvent(editedTodo));
              },
            ),
            Expanded(child: Text(todo.title)),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                context.bloc<TodoListBloc>().add(TodoDeletedEvent(todo.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
