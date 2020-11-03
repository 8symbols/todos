import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/todos_list/bloc/todo_list_bloc.dart';
import 'package:todos/presentation/todos_list/todo_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              ...todos
                  .map((todo) => TodoCard(
                        todo,
                        onDelete: () => _deleteTodo(context, todo),
                        onEdit: (editedTodo) =>
                            _editTodo(context, todo.id, editedTodo),
                      ))
                  .toList(),
              const SizedBox(height: emptySpaceForFabHeight),
            ],
          );
  }

  void _deleteTodo(BuildContext context, Todo todo) {
    context.bloc<TodoListBloc>().add(TodoDeletedEvent(todo.id));

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Задача "${todo.title}" удалена'),
          action: SnackBarAction(
            label: "Отменить",
            onPressed: () =>
                context.bloc<TodoListBloc>().add(TodoAddedEvent(todo)),
          ),
        ),
      );
  }

  void _editTodo(BuildContext context, String todoId, Todo editedTodo) {
    context.bloc<TodoListBloc>().add(TodoEditedEvent(editedTodo));
  }
}
