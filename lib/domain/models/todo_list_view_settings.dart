import 'package:enum_to_string/enum_to_string.dart';
import 'package:todos/domain/models/todos_sort_order.dart';

/// Настройки отображения списка задач.
class TodoListViewSettings {
  /// Показывать ли выполненные задачи.
  final bool areCompletedTodosVisible;

  /// Показывать ли не избранные задачи.
  final bool areNonFavoriteTodosVisible;

  /// Порядок сортировки.
  final TodosSortOrder sortOrder;

  const TodoListViewSettings({
    this.areCompletedTodosVisible = true,
    this.areNonFavoriteTodosVisible = true,
    this.sortOrder = TodosSortOrder.creation,
  });

  TodoListViewSettings copyWith({
    bool areCompletedTodosVisible,
    bool areNonFavoriteTodosVisible,
    TodosSortOrder sortOrder,
  }) {
    return TodoListViewSettings(
      areCompletedTodosVisible:
          areCompletedTodosVisible ?? this.areCompletedTodosVisible,
      areNonFavoriteTodosVisible:
          areNonFavoriteTodosVisible ?? this.areNonFavoriteTodosVisible,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory TodoListViewSettings.fromJson(Map<String, dynamic> json) =>
      TodoListViewSettings(
        areCompletedTodosVisible: json['areCompletedTodosVisible'],
        areNonFavoriteTodosVisible: json['areNonFavoriteTodosVisible'],
        sortOrder:
            EnumToString.fromString(TodosSortOrder.values, json['sortOrder']),
      );

  Map<String, dynamic> toJson() => {
        'areCompletedTodosVisible': areCompletedTodosVisible,
        'areNonFavoriteTodosVisible': areNonFavoriteTodosVisible,
        'sortOrder': EnumToString.convertToString(sortOrder),
      };
}
