import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/todos_list/bloc/todos_list_bloc.dart';

class TodoCard extends StatelessWidget {
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
                context
                    .bloc<TodosListBloc>()
                    .add(TodoEditedEvent(todo.id, editedTodo));
              },
            ),
            Expanded(child: Text(todo.title)),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                context.bloc<TodosListBloc>().add(TodoDeletedEvent(todo.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}