import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';
import 'package:todos/presentation/screens/todos_list/blocs/branch_cubit/branch_cubit.dart';
import 'package:todos/presentation/screens/todos_list/blocs/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/domain/models/todos_sort_order.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list_screen.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/branch_editor_dialog.dart';
import 'package:todos/presentation/widgets/branch_theme_selector.dart';
import 'package:todos/presentation/widgets/popup_menu.dart';
import 'package:todos/presentation/widgets/todos_sort_order_selector.dart';

/// Виджет выпадающего списка в меню [AppBar] экрана списка задач.
class TodoListScreenMenuOptions extends StatelessWidget {
  /// Ветка задач.
  ///
  /// Может быть равным null.
  final Branch branch;

  /// Состояние списка задач.
  final TodoListState todoListState;

  TodoListScreenMenuOptions(this.branch, this.todoListState);

  @override
  Widget build(BuildContext context) {
    final hideCompletedTodosOption = PopupMenuItemData(
      Icons.visibility_off_outlined,
      'Скрыть выполненные',
      onSelected: _hideCompletedTodos,
    );

    final showCompletedTodosOption = PopupMenuItemData(
      Icons.visibility_outlined,
      'Показать выполненные',
      onSelected: _showCompletedTodos,
    );

    final hideNonFavoriteTodosOption = PopupMenuItemData(
      Icons.star,
      'Только избранные',
      onSelected: _hideNonFavoriteTodos,
    );

    final showNonFavoriteTodosOption = PopupMenuItemData(
      Icons.star_outline,
      'Все задачи',
      onSelected: _showNonFavoriteTodos,
    );

    final deleteCompletedTodosOption = PopupMenuItemData(
      Icons.delete_outline,
      'Удалить выполненные',
      onSelected: _deleteCompletedTodos,
    );

    final chooseSortOrderOption = PopupMenuItemData(
      Icons.sort,
      'Сортировать',
      onSelected: _chooseSortOrder,
    );

    final chooseThemeOption = PopupMenuItemData(
      Icons.style_outlined,
      'Выбрать тему',
      onSelected: _chooseBranchTheme,
    );

    final editBranchOption = PopupMenuItemData(
      Icons.edit_outlined,
      'Редактировать ветку',
      onSelected: _editBranch,
    );

    return PopupMenu([
      if (todoListState.todosStatistics != null) ...[
        todoListState.viewSettings.areCompletedTodosVisible
            ? hideCompletedTodosOption
            : showCompletedTodosOption,
        todoListState.viewSettings.areNonFavoriteTodosVisible
            ? hideNonFavoriteTodosOption
            : showNonFavoriteTodosOption,
        chooseSortOrderOption,
        deleteCompletedTodosOption,
      ],
      if (branch != null) ...[
        chooseThemeOption,
        editBranchOption,
      ],
    ]);
  }

  void _hideCompletedTodos(BuildContext context) {
    _setCompletedVisibility(context, false);
  }

  void _showCompletedTodos(BuildContext context) {
    _setCompletedVisibility(context, true);
  }

  void _hideNonFavoriteTodos(BuildContext context) {
    _setNonFavoriteVisibility(context, false);
  }

  void _showNonFavoriteTodos(BuildContext context) {
    _setNonFavoriteVisibility(context, true);
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
      child: TodosSortOrderSelector(),
    );

    if (chosenSortOrder != null) {
      final newViewSettings = context
          .read<TodoListBloc>()
          .state
          .viewSettings
          .copyWith(sortOrder: chosenSortOrder);
      context
          .read<TodoListBloc>()
          .add(ViewSettingsChangedEvent(newViewSettings));
    }
  }

  void _chooseBranchTheme(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(TodoListScreen.routeName));

    showBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Выбор темы',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            BlocBuilder<BranchCubit, Branch>(
              builder: (context, state) => BranchThemeSelector(
                BranchThemes.branchThemes,
                state.theme,
                onSelect: (selectedTheme) => context
                    .read<BranchCubit>()
                    .editBranch(state.copyWith(theme: selectedTheme)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _editBranch(BuildContext context) async {
    final branch = context.read<BranchCubit>().state;

    final editedBranch = await showDialog<Branch>(
      context: context,
      child: BranchEditorDialog(branch),
    );

    if (editedBranch != null && editedBranch != branch) {
      context.read<BranchCubit>().editBranch(editedBranch);
    }
  }

  void _setCompletedVisibility(BuildContext context, bool areVisible) {
    final newViewSettings = context
        .read<TodoListBloc>()
        .state
        .viewSettings
        .copyWith(areCompletedTodosVisible: areVisible);
    context.read<TodoListBloc>().add(ViewSettingsChangedEvent(newViewSettings));
  }

  void _setNonFavoriteVisibility(BuildContext context, bool areVisible) {
    final newViewSettings = context
        .read<TodoListBloc>()
        .state
        .viewSettings
        .copyWith(areNonFavoriteTodosVisible: areVisible);
    context.read<TodoListBloc>().add(ViewSettingsChangedEvent(newViewSettings));
  }
}
