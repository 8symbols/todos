import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/models/todo.dart';

/// Представление [TodoStep] в Floor.
@Entity(
  tableName: 'todos_steps',
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
class FloorTodoStep {
  /// Представление [TodoStep.id].
  @primaryKey
  @ColumnInfo(name: 'id', nullable: false)
  final String id;

  /// Представление [TodoStep.wasCompleted].
  @ColumnInfo(name: 'was_completed', nullable: false)
  final bool wasCompleted;

  /// Представление [TodoStep.title].
  @ColumnInfo(name: 'title', nullable: false)
  final String title;

  /// Идентификатор задачи [Todo.id], к которой относится этот шаг.
  @ColumnInfo(name: 'todo_id', nullable: false)
  final String todoId;

  const FloorTodoStep(
    this.todoId,
    this.title, {
    this.id,
    this.wasCompleted,
  });
}
