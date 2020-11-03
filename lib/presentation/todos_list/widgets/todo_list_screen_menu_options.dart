import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';
import 'package:todos/presentation/todos_list/bloc/todo_list_bloc.dart';
import 'package:todos/presentation/todos_list/models/todos_sort_order.dart';
import 'package:todos/presentation/widgets/popup_menu.dart';

class TodoListScreenMenuOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hideCompletedTodosOption = PopupMenuItemData(
        Icons.visibility_off_outlined, 'Скрыть выполненные',
        onSelected: _hideCompletedTodos);

    final showCompletedTodosOption = PopupMenuItemData(
        Icons.visibility_outlined, 'Показать выполненные',
        onSelected: _showCompletedTodos);

    final deleteCompletedTodosOption = PopupMenuItemData(
        Icons.delete_outline, 'Удалить выполненные',
        onSelected: _deleteCompletedTodos);

    final chooseSortOrderOption = PopupMenuItemData(Icons.sort, 'Сортировать',
        onSelected: _chooseSortOrder);

    final chooseThemeOption = PopupMenuItemData(
        Icons.style_outlined, 'Выбрать тему',
        onSelected: _chooseBranchTheme);

    return BlocBuilder<TodoListBloc, TodoListState>(
      buildWhen: (previous, current) =>
          previous.areCompletedTodosVisible != current.areCompletedTodosVisible,
      builder: (context, state) => PopupMenu([
        state.areCompletedTodosVisible
            ? hideCompletedTodosOption
            : showCompletedTodosOption,
        deleteCompletedTodosOption,
        chooseSortOrderOption,
        chooseThemeOption,
      ]),
    );
  }

  void _hideCompletedTodos(BuildContext context) {
    context
        .bloc<TodoListBloc>()
        .add(CompletedTodosVisibilityChangedEvent(false));
  }

  void _showCompletedTodos(BuildContext context) {
    context
        .bloc<TodoListBloc>()
        .add(CompletedTodosVisibilityChangedEvent(true));
  }

  void _deleteCompletedTodos(BuildContext context) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: const Text(
              'Удалить выполненные задачи? Это действие необратимо.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Подтвердить'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );

    if (wasDeletionConfirmed == true) {
      context.bloc<TodoListBloc>().add(CompletedTodosDeletedEvent());
    }
  }

  void _chooseSortOrder(BuildContext context) async {
    final chosenSortOrder = await showDialog<TodosSortOrder>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Выберите порядок сортировки'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('Дата создания (сначала новые)'),
              onPressed: () => Navigator.pop(context, TodosSortOrder.creation),
            ),
            SimpleDialogOption(
              child: const Text('Дата создания (сначала старые)'),
              onPressed: () =>
                  Navigator.pop(context, TodosSortOrder.creationAsc),
            ),
            SimpleDialogOption(
              child: const Text('Дедлайн (сначала далекие от дедлайна)'),
              onPressed: () => Navigator.pop(context, TodosSortOrder.deadline),
            ),
            SimpleDialogOption(
              child: const Text('Дедлайн (сначала близкие к дедлайну)'),
              onPressed: () =>
                  Navigator.pop(context, TodosSortOrder.deadlineAsc),
            ),
          ],
        );
      },
    );

    if (chosenSortOrder != null) {
      context
          .bloc<TodoListBloc>()
          .add(TodosSortOrderChangedEvent(chosenSortOrder));
    }
  }

  void _chooseBranchTheme(BuildContext context) {}
}
