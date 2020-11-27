import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_todo.dart';
import 'package:todos/domain/models/todo.dart';

/// Представление пути к изображению задачи в Floor.
@Entity(
  tableName: 'todos_images',
  primaryKeys: ['image_path', 'todo_id'],
  foreignKeys: [
    ForeignKey(
      childColumns: ['todo_id'],
      parentColumns: ['id'],
      entity: FloorTodo,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['todo_id']),
  ],
)
class FloorTodoImage {
  /// Путь к изображению.
  @ColumnInfo(name: 'image_path', nullable: false)
  final String imagePath;

  /// Идентификатор задачи [Todo.id], к которой относится это изображение.
  @ColumnInfo(name: 'todo_id', nullable: false)
  final String todoId;

  const FloorTodoImage(this.todoId, this.imagePath);
}
