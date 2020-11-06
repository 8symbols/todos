import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

part 'todo_steps_event.dart';
part 'todo_steps_state.dart';

/// BLoC, управляющий состоянием списка пунктов задачи.
class TodoStepsBloc extends Bloc<TodoStepsEvent, TodoStepsState> {
  /// Задача.
  final Todo _todo;

  /// Интерактор для взаимодействия с пунктами.
  final TodosInteractor _todosInteractor;

  TodoStepsBloc(ITodosRepository todosRepository, this._todo)
      : _todosInteractor = TodosInteractor(todosRepository),
        super(StepsLoadingState());

  @override
  Stream<TodoStepsState> mapEventToState(
    TodoStepsEvent event,
  ) async* {
    if (event is StepsLoadingRequestedEvent) {
      yield* _mapStepsLoadingRequestedEventToState(event);
    } else if (event is StepDeletedEvent) {
      yield* _mapStepDeletedEventToState(event);
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
    final steps = await _todosInteractor.getSteps(_todo.id);
    sortSteps(steps);
    yield StepsContentState(steps);
  }

  /// Удаляет пункт задачи из состояния.
  Stream<TodoStepsState> _mapStepDeletedEventToState(
    StepDeletedEvent event,
  ) async* {
    if (state is StepsContentState) {
      await _todosInteractor.deleteStep(event.stepId);
      final steps = await _todosInteractor.getSteps(_todo.id);
      sortSteps(steps);
      yield StepsContentState(steps);
    }
  }

  /// Изменяет пункт задачи в состояние.
  Stream<TodoStepsState> _mapStepEditedEventToState(
    StepEditedEvent event,
  ) async* {
    if (state is StepsContentState) {
      await _todosInteractor.editStep(event.step);
      final steps = await _todosInteractor.getSteps(_todo.id);
      sortSteps(steps);
      yield StepsContentState(steps);
    }
  }

  /// Добавляет пункт задачи в состояние.
  Stream<TodoStepsState> _mapStepAddedEventToState(
    StepAddedEvent event,
  ) async* {
    if (state is StepsContentState) {
      await _todosInteractor.addStep(_todo.id, event.step);
      final steps = await _todosInteractor.getSteps(_todo.id);
      sortSteps(steps);
      yield StepsContentState(steps);
    }
  }

  /// Сортирует пункты задачи по порядку их добавления.
  void sortSteps(List<TodoStep> steps) {
    // TODO: Добавить сортировку.
    // steps.sort((a, b) => a.index - b.index);
  }
}
