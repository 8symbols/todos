import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_todo.dart';
import 'package:todos/data/entities/floor_todo_step.dart';

/// DAO для [FloorTodoStep].
@dao
abstract class FloorTodoStepDao {
  /// Возвращает все шаги задачи с идентификатором [todoId].
  @Query('SELECT * FROM todos_steps WHERE todo_id = :todoId')
  Future<List<FloorTodoStep>> findStepsOfTodo(String todoId);

  /// Возвращает шаг задачи с идентификатором [id].
  @Query('SELECT * FROM todos_steps WHERE id = :id')
  Future<FloorTodoStep> findTodoStepById(String id);

  /// Возвращает задачу, которой принадлежит шаг с идентификатором
  /// [stepId].
  @Query(
    'SELECT t.* '
    'FROM todos t '
    'JOIN todos_steps ts '
    'ON ts.todo_id = t.id '
    'WHERE ts.id = :stepId',
  )
  Future<FloorTodo> findTodoOfStep(String stepId);

  /// Добавляет шаг задачи.
  @insert
  Future<void> insertStep(FloorTodoStep step);

  /// Изменяет шаг задачи.
  @update
  Future<void> updateStep(FloorTodoStep step);

  /// Удаляет шаг задачи с идентификатором [id].
  @Query('DELETE FROM todos_steps WHERE id = :id')
  Future<void> deleteStep(String id);
}
