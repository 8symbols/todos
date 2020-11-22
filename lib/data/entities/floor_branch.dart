import 'package:floor/floor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branch_theme.dart';

/// Представление [Branch] в Floor.
@Entity(tableName: 'branches')
class FloorBranch {
  /// Представление [Branch.id].
  @primaryKey
  @ColumnInfo(name: 'id', nullable: false)
  final String id;

  /// Представление [Branch.title].
  @ColumnInfo(name: 'title', nullable: false)
  final String title;

  /// Представление [Branch.theme].
  @ColumnInfo(name: 'branch_theme', nullable: false)
  final BranchTheme theme;

  /// Представление [Branch.lastUsageTime].
  @ColumnInfo(name: 'last_usage_time', nullable: false)
  final DateTime lastUsageTime;

  const FloorBranch(this.title, this.theme, {this.id, this.lastUsageTime});
}
