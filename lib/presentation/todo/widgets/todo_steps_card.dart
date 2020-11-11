import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/wrappers/nullable.dart';
import 'package:todos/presentation/todo/todo_bloc/todo_bloc.dart';
import 'package:todos/presentation/todo/todo_steps_bloc/todo_steps_bloc.dart';
import 'package:todos/presentation/todo/widgets/todo_step_item.dart';

/// Карта с пунктами задачи.
///
/// Также отображает время создания задачи и заметки о ней.
class TodoStepsCard extends StatelessWidget {
  /// Задача.
  final Todo _todo;

  static final _creationDateFormat = DateFormat('dd.MM.yyyy HH:mm');

  TodoStepsCard(this._todo);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoStepsBloc, TodoStepsState>(
      listenWhen: (previous, current) =>
          previous is! StepsLoadingState &&
          current is! StepsLoadingState &&
          previous.steps.every((step) => step.wasCompleted) !=
              current.steps.every((step) => step.wasCompleted),
      listener: (context, state) {
        final wasTodoCompleted =
            context.read<TodoBloc>().state.todo.wasCompleted;
        final wereAllStepsCompleted =
            state.steps.every((step) => step.wasCompleted);
        if (!wasTodoCompleted && wereAllStepsCompleted) {
          _suggestToCompleteTask(context);
        }
      },
      builder: (context, state) => state is StepsLoadingState
          ? const Center(child: CircularProgressIndicator())
          : Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCreationTime(context),
                    for (final step in state.steps)
                      TodoStepItem(
                        step,
                        onDelete: () => _deleteStep(context, step),
                        onEdit: (editedStep) => _editStep(context, editedStep),
                      ),
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить шаг'),
                      onPressed: () => _addStep(context),
                    ),
                    const Divider(indent: 20.0, endIndent: 20.0, thickness: 2),
                    _buildNoteTextField(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCreationTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Text(
        'Создано: ${_creationDateFormat.format(_todo.creationTime)}',
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildNoteTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: const InputDecoration.collapsed(
          hintText: 'Заметки по задаче...',
        ),
        textInputAction: TextInputAction.done,
        maxLines: null,
        initialValue: _todo.note,
        onFieldSubmitted: (value) => _editTodoNote(context, _todo, value),
      ),
    );
  }

  void _deleteStep(BuildContext context, TodoStep step) {
    context.read<TodoStepsBloc>().add(StepDeletedEvent(step.id));
  }

  void _editStep(BuildContext context, TodoStep editedStep) {
    context.read<TodoStepsBloc>().add(StepEditedEvent(editedStep));
  }

  void _addStep(BuildContext context) {
    final newStep = TodoStep('');
    context.read<TodoStepsBloc>().add(StepAddedEvent(newStep));
  }

  void _editTodoNote(BuildContext context, Todo todo, String value) {
    context
        .read<TodoBloc>()
        .add(TodoEditedEvent(todo.copyWith(note: Nullable(value))));
  }

  Future<void> _suggestToCompleteTask(BuildContext context) async {
    final shouldCompleteTodo = await showDialog<bool>(
      context: context,
      child: AlertDialog(
        title: const Text('Все шаги выполнены'),
        content: const Text('Хотите завершить задание?'),
        actions: [
          FlatButton(
            child: const Text('Нет'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            child: const Text('Да'),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );

    if (shouldCompleteTodo == true) {
      context
          .read<TodoBloc>()
          .add(TodoEditedEvent(_todo.copyWith(wasCompleted: true)));
    }
  }
}
