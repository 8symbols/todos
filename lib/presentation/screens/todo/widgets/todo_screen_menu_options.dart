import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_steps_bloc/todo_steps_bloc.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/popup_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/widgets/todo_editor_dialog.dart';

/// Виджет выпадающего списка в меню [AppBar] экрана задачи.
class TodoScreenMenuOptions extends StatelessWidget {
  /// Задача.
  final Todo todo;

  TodoScreenMenuOptions(this.todo);

  @override
  Widget build(BuildContext context) {
    final editTodoOption = PopupMenuItemData(
      Icons.edit_outlined,
      'Редактировать',
      onSelected: _editTodo,
    );

    final deleteTodoOption = PopupMenuItemData(
      Icons.delete_outline,
      'Удалить задачу',
      onSelected: _deleteTodo,
    );

    final deleteCompletedStepsOption = PopupMenuItemData(
      Icons.delete_sweep_outlined,
      'Удалить выполненные шаги',
      onSelected: _deleteCompletedSteps,
    );

    return PopupMenu([
      editTodoOption,
      deleteTodoOption,
      deleteCompletedStepsOption,
    ]);
  }

  void _editTodo(BuildContext context) async {
    final editedTodo = await showDialog<Todo>(
      context: context,
      barrierDismissible: false,
      child: TodoEditorDialog(todo),
    );

    if (editedTodo != null && editedTodo != todo) {
      context.read<TodoBloc>().add(TodoEditedEvent(editedTodo));
    }
  }

  void _deleteTodo(BuildContext context) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      child: const BooleanDialog(
        title: 'Удалить задачу?',
        content: 'Это действие нельзя отменить.',
        acceptButtonText: 'Подтвердить',
        rejectButtonText: 'Отмена',
      ),
    );

    if (wasDeletionConfirmed == true) {
      context.read<TodoBloc>().add(TodoDeletedEvent());
    }
  }

  void _deleteCompletedSteps(BuildContext context) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const BooleanDialog(
        title: 'Подтвердите удаление',
        content: 'Удалить выполненные шаги? Это действие необратимо.',
        acceptButtonText: 'Подтвердить',
        rejectButtonText: 'Отмена',
      ),
    );

    if (wasDeletionConfirmed == true) {
      context.read<TodoStepsBloc>().add(const CompletedStepsDeletedEvent());
    }
  }
}
