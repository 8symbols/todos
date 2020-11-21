import 'package:flutter/material.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/wrappers/nullable.dart';
import 'package:todos/presentation/screens/todo/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/screens/todo/widgets/select_time_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Карта с настройками временных параметров задачи.
class TodoTimeSettingsCard extends StatelessWidget {
  /// Задача.
  final Todo todo;

  TodoTimeSettingsCard(this.todo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            SelectTimeItem(
              const Icon(Icons.notifications_active_outlined),
              'Напомнить',
              todo.notificationTime,
              onDelete: () => context.read<TodoBloc>().add(TodoEditedEvent(
                  todo.copyWith(notificationTime: Nullable(null)))),
              onSelect: (selectedDateTime) => context.read<TodoBloc>().add(
                  TodoEditedEvent(todo.copyWith(
                      notificationTime: Nullable(selectedDateTime)))),
            ),
            const Divider(
              height: 2.0,
              indent: 44.0,
              thickness: 2.0,
            ),
            SelectTimeItem(
              const Icon(Icons.event),
              'Добавить дату выполнения',
              todo.deadlineTime,
              onDelete: () => context.read<TodoBloc>().add(
                  TodoEditedEvent(todo.copyWith(deadlineTime: Nullable(null)))),
              onSelect: (selectedDateTime) => context.read<TodoBloc>().add(
                  TodoEditedEvent(
                      todo.copyWith(deadlineTime: Nullable(selectedDateTime)))),
            ),
          ],
        ),
      ),
    );
  }
}
