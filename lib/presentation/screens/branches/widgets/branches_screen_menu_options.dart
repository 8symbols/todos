import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branches_sort_order.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';
import 'package:todos/presentation/screens/branches/blocs/branches_bloc/branches_bloc.dart';
import 'package:todos/presentation/widgets/branches_sort_order_selector.dart';
import 'package:todos/presentation/widgets/popup_menu.dart';

/// Меню настроек в [AppBar] экрана веток.
class BranchesScreenMenuOptions extends StatelessWidget {
  const BranchesScreenMenuOptions();

  @override
  Widget build(BuildContext context) {
    final chooseSortOrderOption = PopupMenuItemData(
      Icons.sort,
      'Сортировать',
      onSelected: _chooseSortOrder,
    );

    return PopupMenu([
      chooseSortOrderOption,
    ]);
  }

  void _chooseSortOrder(BuildContext context) async {
    final chosenSortOrder = await showDialog<BranchesSortOrder>(
      context: context,
      child: BranchesSortOrderSelector(),
    );

    if (chosenSortOrder != null) {
      final newViewSettings = context
          .read<BranchesBloc>()
          .state
          .viewSettings
          .copyWith(sortOrder: chosenSortOrder);
      context
          .read<BranchesBloc>()
          .add(ViewSettingsChangedEvent(newViewSettings));
    }
  }
}
