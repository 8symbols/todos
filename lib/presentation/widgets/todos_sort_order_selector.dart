import 'package:flutter/material.dart';
import 'package:todos/domain/models/todos_sort_order.dart';

/// Диалог для выбора порядка сортировки задач [TodosSortOrder].
///
/// Возвращает [TodosSortOrder] или null.
class TodosSortOrderSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Выберите порядок сортировки'),
      children: <Widget>[
        SimpleDialogOption(
          child: const Text('Дата создания (сначала новые)'),
          onPressed: () => Navigator.pop(context, TodosSortOrder.creation),
        ),
        SimpleDialogOption(
          child: const Text('Дата создания (сначала старые)'),
          onPressed: () => Navigator.pop(context, TodosSortOrder.creationAsc),
        ),
        SimpleDialogOption(
          child: const Text('Дедлайн (сначала далекие от дедлайна)'),
          onPressed: () => Navigator.pop(context, TodosSortOrder.deadline),
        ),
        SimpleDialogOption(
          child: const Text('Дедлайн (сначала близкие к дедлайну)'),
          onPressed: () => Navigator.pop(context, TodosSortOrder.deadlineAsc),
        ),
      ],
    );
  }
}
