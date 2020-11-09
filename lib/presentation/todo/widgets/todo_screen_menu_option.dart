import 'package:flutter/material.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';
import 'package:todos/presentation/todo/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/widgets/popup_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Виджет выпадающего списка в меню [AppBar] экрана задачи.
class TodoScreenMenuOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final editTodoOption = PopupMenuItemData(
        Icons.edit_outlined, 'Редактировать',
        onSelected: _editTodo);

    final deleteTodoOption = PopupMenuItemData(Icons.delete_outline, 'Удалить',
        onSelected: _deleteTodo);

    return PopupMenu([
      editTodoOption,
      deleteTodoOption,
    ]);
  }

  void _editTodo(BuildContext context) {}

  void _deleteTodo(BuildContext context) {
    context.bloc<TodoBloc>().add(TodoDeletedEvent());
  }
}