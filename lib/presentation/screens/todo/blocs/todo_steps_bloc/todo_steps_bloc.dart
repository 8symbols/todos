import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';

part 'todo_steps_event.dart';
part 'todo_steps_state.dart';

/// BLoC, управляющий состоянием списка пунктов задачи.
class TodoStepsBloc extends Bloc<TodoStepsEvent, TodoStepsState> {
  /// Задача.
  final Todo _todo;

  /// Интерактор для взаимодействия с пунктами.
  final TodosInteractor _todosInteractor;

  TodoStepsBloc(this._todosInteractor, this._todo) : super(StepsLoadingState());

  @override
  Stream<TodoStepsState> mapEventToState(
    TodoStepsEvent event,
  ) async* {
    if (event is StepsLoadingRequestedEvent) {
      yield* _mapStepsLoadingRequestedEventToState(event);
    } else if (event is StepDeletedEvent) {
      yield* _mapStepDeletedEventToState(event);
    } else if (event is CompletedStepsDeletedEvent) {
      yield* _mapCompletedStepsDeletedEventToState(event);
    } else if (event is StepEditedEvent) {
      yield* _mapStepEditedEventToState(event);
    } else if (event is StepAddedEvent) {
      yield* _mapStepAddedEventToState(event);
    }
  }

  /// Загружает пункты задачи.
  Stream<TodoStepsState> _mapStepsLoadingRequestedEventToState(
    StepsLoadingRequestedEvent event,
  ) async* {
    final steps = await _todosInteractor.getStepsOfTodo(_todo.id);
    yield StepsContentState(steps);
  }

  /// Удаляет пункт задачи.
  Stream<TodoStepsState> _mapStepDeletedEventToState(
    StepDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteTodoStep(event.stepId);
    final steps = await _todosInteractor.getStepsOfTodo(_todo.id);
    yield StepsContentState(steps);
  }

  /// Удаляет завершенные пункты задачи.
  Stream<TodoStepsState> _mapCompletedStepsDeletedEventToState(
    CompletedStepsDeletedEvent event,
  ) async* {
    await _todosInteractor.deleteCompletedStepsOfTodo(_todo.id);
    final steps = await _todosInteractor.getStepsOfTodo(_todo.id);
    yield StepsContentState(steps);
  }

  /// Изменяет пункт задачи.
  Stream<TodoStepsState> _mapStepEditedEventToState(
    StepEditedEvent event,
  ) async* {
    await _todosInteractor.editTodoStep(event.step);
    final steps = await _todosInteractor.getStepsOfTodo(_todo.id);
    yield StepsContentState(steps);
  }

  /// Добавляет пункт задачи.
  Stream<TodoStepsState> _mapStepAddedEventToState(
    StepAddedEvent event,
  ) async* {
    await _todosInteractor.addTodoStep(_todo.id, event.step);
    final steps = await _todosInteractor.getStepsOfTodo(_todo.id);
    yield StepAddedState(steps);
  }
}
