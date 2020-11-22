import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branches_sort_order.dart';

/// Фабрика для получения компараторов по порядку сортировки [BranchesSortOrder].
abstract class BranchesComparatorsFactory {
  static final _comparators = <BranchesSortOrder, Comparator<Branch>>{
    BranchesSortOrder.usage: (a, b) {
      return b.lastUsageTime.millisecondsSinceEpoch -
          a.lastUsageTime.millisecondsSinceEpoch;
    },
  };

  /// Возвращает компаратор для порядка сортировки [BranchesSortOrder].
  static Comparator<Branch> getComparator(BranchesSortOrder sortOrder) {
    return _comparators[sortOrder];
  }
}
