import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/todo/models/todo_screen_arguments.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_screen.dart';
import 'package:todos/presentation/screens/todos_list/branch_cubit/branch_cubit.dart';
import 'package:todos/presentation/screens/todos_list/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/screens/todos_list/models/todo_view_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/screens/todos_list/widgets/empty_todo_list.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_card.dart';

/// Виджет для отображения списка задач.
class TodoList extends StatelessWidget {
  /// Список задач.
  final List<TodoViewData> todosData;

  TodoList(this.todosData);

  @override
  Widget build(BuildContext context) {
    const emptySpaceForFabHeight = 88.0;

    return todosData.isEmpty
        ? EmptyTodoList()
        : Stack(
            children: [
              _buildBackgroundLines(context),
              ListView(
                children: [
                  const SizedBox(height: 6.0),
                  ...todosData
                      .map((todoData) => TodoCard(
                            todoData,
                            onDelete: () => _deleteTodo(context, todoData.todo),
                            onEdit: (editedTodo) => _editTodo(
                                context, todoData.todo.id, editedTodo),
                            onTap: () =>
                                _openTodoScreen(context, todoData.todo),
                          ))
                      .toList(),
                  const SizedBox(height: emptySpaceForFabHeight),
                ],
              ),
            ],
          );
  }

  Widget _buildBackgroundLines(BuildContext context) {
    const backgroundLineThickness = 2.0;
    const backgroundLinesDistance = 70.0;

    const backgroundLine = Padding(
      padding: EdgeInsets.only(top: backgroundLinesDistance),
      child: Divider(
        height: backgroundLineThickness,
        indent: 25.0,
        endIndent: 25.0,
        color: Color(0xFF9DA3B5),
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

  void _deleteTodo(BuildContext context, Todo todo) {
    context.read<TodoListBloc>().add(TodoDeletedEvent(todo));
  }

  void _editTodo(BuildContext context, String todoId, Todo editedTodo) {
    context.read<TodoListBloc>().add(TodoEditedEvent(editedTodo));
  }

  void _openTodoScreen(BuildContext context, Todo todo) async {
    final branchTheme = context.read<BranchCubit>().state?.theme ??
        BranchThemes.defaultBranchTheme;
    final arguments = TodoScreenArguments(branchTheme, todo);
    await Navigator.of(context)
        .pushNamed(TodoScreen.routeName, arguments: arguments);
    context.read<TodoListBloc>().add(InitializationRequestedEvent());
  }
}