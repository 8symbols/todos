import 'package:enum_to_string/enum_to_string.dart';
import 'package:todos/domain/models/branches_sort_order.dart';

/// Настройки отображения списка веток.
class BranchesViewSettings {
  /// Порядок сортировки.
  final BranchesSortOrder sortOrder;

  const BranchesViewSettings({
    this.sortOrder = BranchesSortOrder.creation,
  });

  BranchesViewSettings copyWith({
    BranchesSortOrder sortOrder,
  }) {
    return BranchesViewSettings(
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory BranchesViewSettings.fromJson(Map<String, dynamic> json) =>
      BranchesViewSettings(
        sortOrder: EnumToString.fromString(
          BranchesSortOrder.values,
          json['sort_order'],
        ),
      );

  Map<String, dynamic> toJson() => {
        'sort_order': EnumToString.convertToString(sortOrder),
      };
}
