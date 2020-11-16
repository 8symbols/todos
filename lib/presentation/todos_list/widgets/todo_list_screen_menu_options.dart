import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/presentation/branch_themes.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';
import 'package:todos/presentation/todos_list/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/todos_list/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/domain/models/todos_sort_order.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/branch_theme_selector.dart';
import 'package:todos/presentation/widgets/popup_menu.dart';

/// Виджет выпадающего списка в меню [AppBar] экрана списка задач.
class TodoListScreenMenuOptions extends StatelessWidget {
  /// Флаг, сигнализирующий о том, все ли задачи из списка принадлежат
  /// одной ветке.
  final bool areTodosFromSameBranch;

  TodoListScreenMenuOptions(this.areTodosFromSameBranch);

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
        if (areTodosFromSameBranch) chooseThemeOption,
      ]),
    );
  }

  void _hideCompletedTodos(BuildContext context) {
    context
        .read<TodoListBloc>()
        .add(CompletedTodosVisibilityChangedEvent(false));
  }

  void _showCompletedTodos(BuildContext context) {
    context
        .read<TodoListBloc>()
        .add(CompletedTodosVisibilityChangedEvent(true));
  }

  void _deleteCompletedTodos(BuildContext context) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const BooleanDialog(
        title: 'Подтвердите удаление',
        content: 'Удалить выполненные задачи? Это действие необратимо.',
        acceptButtonText: 'Подтвердить',
        rejectButtonText: 'Отмена',
      ),
    );

    if (wasDeletionConfirmed == true) {
      context.read<TodoListBloc>().add(CompletedTodosDeletedEvent());
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
          .read<TodoListBloc>()
          .add(TodosSortOrderChangedEvent(chosenSortOrder));
    }
  }

  void _chooseBranchTheme(BuildContext context) {
    showBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Выбор темы',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),
              BlocBuilder<ThemeCubit, BranchTheme>(
                builder: (context, state) => BranchThemeSelector(
                  BranchThemes.branchThemes,
                  state,
                  onSelect: (selectedTheme) =>
                      context.read<ThemeCubit>().changeTheme(selectedTheme),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
