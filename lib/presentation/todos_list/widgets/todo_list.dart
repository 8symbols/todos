import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/branch_themes.dart';
import 'package:todos/presentation/todo/models/todo_screen_arguments.dart';
import 'package:todos/presentation/todo/widgets/todo_screen.dart';
import 'package:todos/presentation/todos_list/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/todos_list/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/todos_list/models/todo_card_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/todos_list/widgets/todo_card.dart';

/// Виджет для отображения списка задач.
class TodoList extends StatelessWidget {
  /// Список задач.
  final List<TodoViewData> todosData;

  TodoList(this.todosData);

  @override
  Widget build(BuildContext context) {
    const emptySpaceForFabHeight = 88.0;

    return todosData.isEmpty
        ? _buildEmptyList()
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
    context.bloc<TodoListBloc>().add(TodoDeletedEvent(todo));
  }

  void _editTodo(BuildContext context, String todoId, Todo editedTodo) {
    context.bloc<TodoListBloc>().add(TodoEditedEvent(editedTodo));
  }

  void _openTodoScreen(BuildContext context, Todo todo) async {
    final branchTheme =
        context.bloc<ThemeCubit>().state ?? BranchThemes.defaultBranchTheme;
    final arguments = TodoScreenArguments(branchTheme, todo);
    await Navigator.of(context)
        .pushNamed(TodoScreen.routeName, arguments: arguments);
    context.bloc<TodoListBloc>().add(TodosListLoadingRequestedEvent());
  }
}
