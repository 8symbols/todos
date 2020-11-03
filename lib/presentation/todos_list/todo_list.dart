import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        ? _buildEmptyList()
        : Stack(
            children: [
              _buildBackgroundLines(context),
              ListView(
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
              ),
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

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/todolist.svg',
            width: 200.0,
            height: 200.0,
          ),
          const SizedBox(height: 16.0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150.0),
            child: const Text(
              'На данный момент задачи отсутствуют',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundLines(BuildContext context) {
    const backgroundLineThickness = 1.0;
    const backgroundLinesDistance = 70.0;

    const backgroundLine = Padding(
      padding: EdgeInsets.only(top: backgroundLinesDistance),
      child: Divider(
        height: backgroundLineThickness,
        indent: 20.0,
        endIndent: 20.0,
        color: Colors.grey,
        thickness: backgroundLineThickness,
      ),
    );

    final backgroundLinesCount = MediaQuery.of(context).size.height ~/
            (backgroundLinesDistance + backgroundLineThickness) +
        1;

    return Wrap(
      children: [for (var i = 0; i < backgroundLinesCount; ++i) backgroundLine],
    );
  }
}
