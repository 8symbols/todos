import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_branch.dart';
import 'package:todos/data/entities/floor_todo.dart';

/// DAO для [FloorTodo].
@dao
abstract class FloorTodoDao {
  /// Возвращает все задачи.
  @Query('SELECT * FROM todos')
  Future<List<FloorTodo>> findAllTodos();

  /// Возвращает все задачи из ветки с идентификатором [branchId].
  @Query('SELECT * FROM todos WHERE branch_id = :branchId')
  Future<List<FloorTodo>> findTodosOfBranch(String branchId);

  /// Возвращает ветку, которой принадлежит задача с идентификатором
  /// [todoId].
  @Query(
    'SELECT b.* '
    'FROM branches b '
    'JOIN todos t '
    'ON t.branch_id = b.id '
    'WHERE t.id = :todoId',
  )
  Future<FloorBranch> findBranchOfTodo(String todoId);

  /// Возвращает задачу с идентификатором [id].
  @Query('SELECT * FROM todos WHERE id = :id')
  Future<FloorTodo> findTodoById(String id);

  /// Добавляет задачу.
  @insert
  Future<void> insertTodo(FloorTodo todo);

  /// Изменяет задачу.
  @update
  Future<void> updateTodo(FloorTodo todo);

  /// Удаляет задачу с идентификатором [id].
  @Query('DELETE FROM todos WHERE id = :id')
  Future<void> deleteTodo(String id);
}
