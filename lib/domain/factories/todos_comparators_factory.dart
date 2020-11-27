import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todos_sort_order.dart';

/// Фабрика для получения компараторов по порядку сортировки [TodosSortOrder].
abstract class TodosComparatorsFactory {
  static final Comparator<DateTime> _datetimeComparator =
      (a, b) => b.millisecondsSinceEpoch - a.millisecondsSinceEpoch;

  static final _comparators = <TodosSortOrder, Comparator<Todo>>{
    TodosSortOrder.creation: (a, b) {
      return _datetimeComparator(a.creationTime, b.creationTime);
    },
    TodosSortOrder.creationAsc: (a, b) {
      return -_datetimeComparator(a.creationTime, b.creationTime);
    },
    TodosSortOrder.deadline: (a, b) {
      if (a.deadlineTime == null && b.deadlineTime == null) return 0;
      if (a.deadlineTime == null) return 1;
      if (b.deadlineTime == null) return -1;
      return _datetimeComparator(a.deadlineTime, b.deadlineTime);
    },
    TodosSortOrder.deadlineAsc: (a, b) {
      if (a.deadlineTime == null && b.deadlineTime == null) return 0;
      if (a.deadlineTime == null) return 1;
      if (b.deadlineTime == null) return -1;
      return -_datetimeComparator(a.deadlineTime, b.deadlineTime);
    }
  };

  /// Возвращает компаратор для порядка сортировки [TodosSortOrder].
  static Comparator<Todo> getComparator(TodosSortOrder sortOrder) {
    return _comparators[sortOrder];
  }
}
