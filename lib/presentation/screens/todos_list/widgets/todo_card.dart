import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todos_list/models/todo_statistics.dart';
import 'package:todos/presentation/widgets/favorite_button.dart';

typedef TodoEditedCallback = void Function(Todo editedTodo);

/// Виджет для отображения задачи в списке задач.
class TodoCard extends StatelessWidget {
  /// Задача.
  final TodoStatistics todoData;

  /// Callback, вызывающийся при удалении задачи.
  final VoidCallback onDelete;

  /// Callback, вызывающийся при нажатии на задачу.
  final VoidCallback onTap;

  /// Callback, вызывающийся при изменении задачи.
  final TodoEditedCallback onEdit;

  static final _deadlineDateFormat = DateFormat('dd.MM.yyyy HH:mm');

  TodoCard(
    this.todoData, {
    @required this.onDelete,
    @required this.onEdit,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardMargin = EdgeInsets.symmetric(vertical: 6.0);

    final dismissibleBackground = Container(
      margin: cardMargin,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Dismissible(
        key: Key(todoData.todo.id),
        direction: DismissDirection.endToStart,
        background: dismissibleBackground,
        confirmDismiss: (direction) async => ModalRoute.of(context).isCurrent,
        onDismissed: (direction) => onDelete(),
        child: Card(
          margin: cardMargin,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  CircularCheckBox(
                    value: todoData.todo.wasCompleted,
                    onChanged: (newValue) =>
                        onEdit(todoData.todo.copyWith(wasCompleted: newValue)),
                  ),
                  Expanded(child: _buildTodoData()),
                  FavoriteButton(
                    todoData.todo.isFavorite,
                    onToggle: (isFavorite) =>
                        onEdit(todoData.todo.copyWith(isFavorite: isFavorite)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodoData() {
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
              'До ${_deadlineDateFormat.format(todoData.todo.deadlineTime)}',
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
