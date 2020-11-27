import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/branch.dart';

/// Представление [Todo] в Floor.
@Entity(
  tableName: 'todos',
  foreignKeys: [
    ForeignKey(
      childColumns: ['branch_id'],
      parentColumns: ['id'],
      entity: FloorBranch,
      onDelete: ForeignKeyAction.cascade,
      onUpdate: ForeignKeyAction.cascade,
    )
  ],
  indices: [
    Index(value: ['branch_id']),
  ],
)
class FloorTodo {
  /// Представление [Todo.id].
  @primaryKey
  @ColumnInfo(name: 'id', nullable: false)
  final String id;

  /// Представление [Todo.isFavorite].
  @ColumnInfo(name: 'is_favorite', nullable: false)
  final bool isFavorite;

  /// Представление [Todo.wasCompleted].
  @ColumnInfo(name: 'was_completed', nullable: false)
  final bool wasCompleted;

  /// Представление [Todo.title].
  @ColumnInfo(name: 'title', nullable: false)
  final String title;

  /// Представление [Todo.note].
  @ColumnInfo(name: 'note', nullable: true)
  final String note;

  /// Представление [Todo.deadlineTime].
  @ColumnInfo(name: 'deadline_time', nullable: true)
  final DateTime deadlineTime;

  /// Представление [Todo.notificationTime].
  @ColumnInfo(name: 'notification_time', nullable: true)
  final DateTime notificationTime;

  /// Представление [Todo.creationTime].
  @ColumnInfo(name: 'creation_time', nullable: false)
  final DateTime creationTime;

  /// Представление [Todo.mainImagePath].
  @ColumnInfo(name: 'main_image_path', nullable: true)
  final String mainImagePath;

  /// Идентификатор ветки [Branch.id], к которой относится эта задача.
  @ColumnInfo(name: 'branch_id', nullable: false)
  final String branchId;

  const FloorTodo(
    this.branchId,
    this.title, {
    this.id,
    this.creationTime,
    this.isFavorite,
    this.wasCompleted,
    this.mainImagePath,
    this.note,
    this.deadlineTime,
    this.notificationTime,
  });
}
