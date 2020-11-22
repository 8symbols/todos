import 'package:enum_to_string/enum_to_string.dart';
import 'package:todos/domain/models/todos_sort_order.dart';

/// Настройки отображения списка задач.
class TodosViewSettings {
  /// Показывать ли выполненные задачи.
  final bool areCompletedTodosVisible;

  /// Показывать ли не избранные задачи.
  final bool areNonFavoriteTodosVisible;

  /// Порядок сортировки.
  final TodosSortOrder sortOrder;

  const TodosViewSettings({
    this.areCompletedTodosVisible = true,
    this.areNonFavoriteTodosVisible = true,
    this.sortOrder = TodosSortOrder.creation,
  });

  TodosViewSettings copyWith({
    bool areCompletedTodosVisible,
    bool areNonFavoriteTodosVisible,
    TodosSortOrder sortOrder,
  }) {
    return TodosViewSettings(
      areCompletedTodosVisible:
          areCompletedTodosVisible ?? this.areCompletedTodosVisible,
      areNonFavoriteTodosVisible:
          areNonFavoriteTodosVisible ?? this.areNonFavoriteTodosVisible,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  factory TodosViewSettings.fromJson(Map<String, dynamic> json) =>
      TodosViewSettings(
        areCompletedTodosVisible: json['are_completed_todos_visible'],
        areNonFavoriteTodosVisible: json['are_non_favorite_todos_visible'],
        sortOrder:
            EnumToString.fromString(TodosSortOrder.values, json['sort_order']),
      );

  Map<String, dynamic> toJson() => {
        'are_completed_todos_visible': areCompletedTodosVisible,
        'are_non_favorite_todos_visible': areNonFavoriteTodosVisible,
        'sort_order': EnumToString.convertToString(sortOrder),
      };
}
