import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_todo_image.dart';

/// DAO для [FloorTodoImage].
@dao
abstract class FloorTodoImageDao {
  /// Возвращает все изображения задачи с идентификатором [todoId].
  @Query('SELECT * FROM todos_images WHERE todo_id = :todoId')
  Future<List<FloorTodoImage>> findImagesOfTodo(String todoId);

  /// Добавляет изображение.
  @insert
  Future<void> insertImage(FloorTodoImage image);

  /// Удаляет изображение.
  @delete
  Future<void> deleteImage(FloorTodoImage image);
}
