import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/todos_list/models/todo_card_data.dart';

typedef void TodoEditedCallback(Todo editedTodo);

/// Виджет для отображения задачи в списке задач.
class TodoCard extends StatelessWidget {
  /// Задача.
  final TodoViewData todoData;

  /// Callback, вызывающийся при удалении задачи.
  final VoidCallback onDelete;

  /// Callback, вызывающийся при изменении задачи.
  final TodoEditedCallback onEdit;

  TodoCard(this.todoData, {@required this.onDelete, @required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final dismissibleBackground = Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [Icon(Icons.delete), SizedBox(width: 12.0)],
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Dismissible(
        key: Key(todoData.todo.id),
        direction: DismissDirection.endToStart,
        background: dismissibleBackground,
        onDismissed: (direction) => onDelete(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Checkbox(
                value: todoData.todo.wasCompleted,
                onChanged: (newValue) =>
                    onEdit(todoData.todo.copyWith(wasCompleted: newValue)),
              ),
              Expanded(child: _buildTodoData()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodoData() {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(todoData.todo.title),
        if (todoData.stepsCount != 0)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              '${todoData.completedStepsCount} из ${todoData.stepsCount}',
              style: const TextStyle(color: Colors.grey, fontSize: 13.5),
            ),
          ),
        if (todoData.todo.deadlineTime != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'До ${dateFormat.format(todoData.todo.deadlineTime)}',
              style: TextStyle(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                color: todoData.todo.deadlineTime.isAfter(DateTime.now())
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
