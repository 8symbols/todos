import 'package:todos/data/entities/floor_todo.dart';
import 'package:todos/domain/models/todo.dart';

/// Mapper для [Todo].
abstract class TodoMapper {
  /// Создает [Todo] на основе [FloorTodo].
  static Todo fromFloorTodo(FloorTodo floorTodo) => Todo(
        floorTodo.title,
        id: floorTodo.id,
        wasCompleted: floorTodo.wasCompleted,
        notificationTime: floorTodo.notificationTime,
        mainImagePath: floorTodo.mainImagePath,
        creationTime: floorTodo.creationTime,
        deadlineTime: floorTodo.deadlineTime,
        isFavorite: floorTodo.isFavorite,
        note: floorTodo.note,
      );

  /// Создает [FloorTodo] на основе [Todo] и идентификатора
  /// ветки [branchId].
  static FloorTodo toFloorTodo(String branchId, Todo todo) => FloorTodo(
        branchId,
        todo.title,
        id: todo.id,
        wasCompleted: todo.wasCompleted,
        notificationTime: todo.notificationTime,
        mainImagePath: todo.mainImagePath,
        creationTime: todo.creationTime,
        deadlineTime: todo.deadlineTime,
        isFavorite: todo.isFavorite,
        note: todo.note,
      );
}
