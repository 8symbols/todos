import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/presentation/todo/todo_steps_bloc/todo_steps_bloc.dart';
import 'package:todos/presentation/todo/widgets/todo_step_widget.dart';

/// Карта с пунктами задачи.
///
/// Также отображает время создания задачи и заметки о ней.
class TodoStepsCard extends StatelessWidget {
  /// Задача.
  final Todo _todo;

  TodoStepsCard(this._todo);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return BlocBuilder<TodoStepsBloc, TodoStepsState>(
      builder: (context, state) => state is StepsLoadingState
          ? const Center(child: CircularProgressIndicator())
          : Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Text(
                        'Создано: ${dateFormat.format(_todo.creationTime)}',
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    for (final step in state.steps)
                      TodoStepWidget(
                        step,
                        onDelete: () => _deleteStep(context, step),
                        onEdit: (editedStep) => _editStep(context, editedStep),
                      ),
                    FlatButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить шаг'),
                      onPressed: () => _addStep(context),
                    ),
                    const Divider(
                      indent: 20.0,
                      endIndent: 20.0,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Заметки по задаче...',
                        ),
                        initialValue: _todo.note,
                        onFieldSubmitted: (value) => print(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _deleteStep(BuildContext context, TodoStep step) {
    context.bloc<TodoStepsBloc>().add(StepDeletedEvent(step.id));
  }

  void _editStep(BuildContext context, TodoStep editedStep) {
    context.bloc<TodoStepsBloc>().add(StepEditedEvent(editedStep));
  }

  void _addStep(BuildContext context) {
    final newStep = TodoStep('');
    context.bloc<TodoStepsBloc>().add(StepAddedEvent(newStep));
  }
}
