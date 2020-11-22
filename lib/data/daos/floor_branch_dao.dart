import 'package:floor/floor.dart';
import 'package:todos/data/entities/floor_branch.dart';

/// DAO для [FloorBranch].
@dao
abstract class FloorBranchDao {
  /// Возвращает все ветки.
  @Query('SELECT * FROM branches')
  Future<List<FloorBranch>> findAllBranches();

  /// Возвращает ветку с идентификатором [id].
  @Query('SELECT * FROM branches WHERE id = :id')
  Future<FloorBranch> findBranchById(String id);

  /// Добавляет ветку.
  @insert
  Future<void> insertBranch(FloorBranch branch);

  /// Изменяет ветку.
  @update
  Future<void> updateBranch(FloorBranch branch);

  /// Удаляет ветку с идентификатором [id].
  @Query('DELETE FROM branches WHERE id = :id')
  Future<void> deleteBranch(String id);
}
