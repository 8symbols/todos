import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';

/// Диалог создания задачи.
class CreateTodoDialog extends StatefulWidget {
  /// Максимальное количество символов в названии.
  ///
  /// Служит только для отображения предупреждений, созданная задача может
  /// иметь более длинное название.
  final int maxTitleLength;

  CreateTodoDialog(this.maxTitleLength);

  @override
  _CreateTodoDialogState createState() => _CreateTodoDialogState();
}

class _CreateTodoDialogState extends State<CreateTodoDialog> {
  /// Новая задача.
  Todo _todo = Todo('');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Создать задачу'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration.collapsed(
              hintText: 'Введите название задачи',
            ),
            maxLength: widget.maxTitleLength,
            maxLengthEnforced: false,
            keyboardType: TextInputType.text,
            onChanged: (value) => _todo = _todo.copyWith(title: value),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: const Text('Отмена'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: const Text('Создать'),
          onPressed: () => Navigator.of(context).pop(_todo),
        ),
      ],
    );
  }
}
