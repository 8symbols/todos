import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/todo_list/models/todo_statistics.dart';
import 'package:todos/presentation/widgets/favorite_button.dart';

typedef TodoEditedCallback = void Function(Todo editedTodo);

/// Виджет для отображения задачи в списке задач.
class TodoCard extends StatelessWidget {
  /// Задача.
  final TodoStatistics statistics;

  /// Callback, вызывающийся при удалении задачи.
  final VoidCallback onDelete;

  /// Callback, вызывающийся при нажатии на задачу.
  final VoidCallback onTap;

  /// Callback, вызывающийся при изменении задачи.
  final TodoEditedCallback onEdit;

  /// Формат отображения времени дедлайна.
  static final deadlineDateFormat = DateFormat('dd.MM.yyyy HH:mm');

  TodoCard(
    this.statistics, {
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
        key: Key(statistics.todo.id),
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
                    value: statistics.todo.wasCompleted,
                    onChanged: (newValue) => onEdit(
                        statistics.todo.copyWith(wasCompleted: newValue)),
                  ),
                  Expanded(child: _buildTodoData()),
                  FavoriteButton(
                    statistics.todo.isFavorite,
                    onToggle: (isFavorite) => onEdit(
                        statistics.todo.copyWith(isFavorite: isFavorite)),
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
        Text(statistics.todo.title),
        if (statistics.stepsCount != 0)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              '${statistics.completedStepsCount} из ${statistics.stepsCount}',
              style: const TextStyle(color: Colors.grey, fontSize: 13.5),
            ),
          ),
        if (statistics.todo.deadlineTime != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'До ${deadlineDateFormat.format(statistics.todo.deadlineTime)}',
              style: TextStyle(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                color: statistics.todo.deadlineTime.isAfter(DateTime.now())
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
