import 'package:todos/data/entities/floor_branch.dart';
import 'package:todos/domain/models/branch.dart';

/// Mapper для [Branch].
abstract class BranchMapper {
  /// Создает [Branch] на основе [FloorBranch].
  static Branch fromFloorBranch(FloorBranch floorBranch) => Branch(
        floorBranch.title,
        floorBranch.theme,
        id: floorBranch.id,
        lastUsageTime: floorBranch.lastUsageTime,
      );

  /// Создает [FloorBranch] на основе [Branch].
  static FloorBranch toFloorBranch(Branch branch) => FloorBranch(
        branch.title,
        branch.theme,
        id: branch.id,
        lastUsageTime: branch.lastUsageTime,
      );
}
