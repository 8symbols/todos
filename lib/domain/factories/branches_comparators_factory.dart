import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branches_sort_order.dart';

/// Фабрика для получения компараторов по порядку сортировки [BranchesSortOrder].
abstract class BranchesComparatorsFactory {
  static final _comparators = <BranchesSortOrder, Comparator<Branch>>{
    BranchesSortOrder.creation: (a, b) {
      return b.creationTime.millisecondsSinceEpoch -
          a.creationTime.millisecondsSinceEpoch;
    },
    BranchesSortOrder.creationAsc: (a, b) {
      return a.creationTime.millisecondsSinceEpoch -
          b.creationTime.millisecondsSinceEpoch;
    },
    BranchesSortOrder.usage: (a, b) {
      return b.lastUsageTime.millisecondsSinceEpoch -
          a.lastUsageTime.millisecondsSinceEpoch;
    },
    BranchesSortOrder.usageAsc: (a, b) {
      return a.lastUsageTime.millisecondsSinceEpoch -
          b.lastUsageTime.millisecondsSinceEpoch;
    },
    BranchesSortOrder.title: (a, b) {
      return b.title.compareTo(a.title);
    },
    BranchesSortOrder.titleAsc: (a, b) {
      return a.title.compareTo(b.title);
    },
  };

  /// Возвращает компаратор для порядка сортировки [BranchesSortOrder].
  static Comparator<Branch> getComparator(BranchesSortOrder sortOrder) {
    return _comparators[sortOrder];
  }
}
