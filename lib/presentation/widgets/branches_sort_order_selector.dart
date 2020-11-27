import 'package:flutter/material.dart';
import 'package:todos/domain/models/branches_sort_order.dart';

/// Диалог для выбора порядка сортировки веток [BranchesSortOrder].
///
/// Возвращает [BranchesSortOrder] или null.
class BranchesSortOrderSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Выберите порядок сортировки'),
      children: <Widget>[
        SimpleDialogOption(
          child: const Text('Дата создания (сначала новые)'),
          onPressed: () => Navigator.pop(context, BranchesSortOrder.creation),
        ),
        SimpleDialogOption(
          child: const Text('Дата создания (сначала старые)'),
          onPressed: () =>
              Navigator.pop(context, BranchesSortOrder.creationAsc),
        ),
        SimpleDialogOption(
          child: const Text('Дата использования (сначала недавние)'),
          onPressed: () => Navigator.pop(context, BranchesSortOrder.usage),
        ),
        SimpleDialogOption(
          child: const Text('Дата использования (сначала давние)'),
          onPressed: () => Navigator.pop(context, BranchesSortOrder.usageAsc),
        ),
        SimpleDialogOption(
          child: const Text('Название (убывание)'),
          onPressed: () => Navigator.pop(context, BranchesSortOrder.title),
        ),
        SimpleDialogOption(
          child: const Text('Название (возрастание)'),
          onPressed: () => Navigator.pop(context, BranchesSortOrder.titleAsc),
        ),
      ],
    );
  }
}
