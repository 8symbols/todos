import 'package:todos/data/entities/floor_todo_step.dart';
import 'package:todos/domain/models/todo_step.dart';

/// Mapper для [TodoStep].
abstract class TodoStepMapper {
  /// Создает [TodoStep] на основе [FloorTodoStep].
  static TodoStep fromFloorTodoStep(FloorTodoStep floorTodoStep) => TodoStep(
        floorTodoStep.title,
        id: floorTodoStep.id,
        wasCompleted: floorTodoStep.wasCompleted,
      );

  /// Создает [FloorTodoStep] на основе [TodoStep] и идентификатора
  /// задачи [todoId].
  static FloorTodoStep toFloorTodoStep(String todoId, TodoStep todoStep) =>
      FloorTodoStep(
        todoId,
        todoStep.title,
        id: todoStep.id,
        wasCompleted: todoStep.wasCompleted,
      );
}
