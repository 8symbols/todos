import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo_step.dart';

typedef StepEditedCallback = void Function(TodoStep editedStep);

/// Виджет для отображения пункта задачи.
class TodoStepItem extends StatelessWidget {
  /// Пункт задачи.
  final TodoStep step;

  /// Callback, вызывающийся при удалении пункта задачи.
  final VoidCallback onDelete;

  /// Callback, вызывающийся при изменении пункта задачи.
  final StepEditedCallback onEdit;

  /// Устанавливать ли автофокус.
  final bool autofocus;

  TodoStepItem(
    this.step,
    this.autofocus, {
    @required this.onDelete,
    @required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ValueKey(step.id),
      children: [
        CircularCheckBox(
          value: step.wasCompleted,
          onChanged: (value) => onEdit(step.copyWith(wasCompleted: value)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: TextFormField(
              decoration: const InputDecoration.collapsed(
                hintText: 'Введите шаг',
              ),
              style: step.wasCompleted
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
              textInputAction: TextInputAction.done,
              maxLines: null,
              initialValue: step.title,
              onFieldSubmitted: (value) => onEdit(step.copyWith(title: value)),
              autofocus: autofocus,
            ),
          ),
        ),
        IconButton(icon: const Icon(Icons.close), onPressed: onDelete)
      ],
    );
  }
}
