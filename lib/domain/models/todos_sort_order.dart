/// Выбор порядка сортировки списка задач.
enum TodosSortOrder {
  /// По времени создания (сначала новые).
  creation,

  /// По времени создания (сначала старые).
  creationAsc,

  /// По времени дедлайна (сначала далекие от дедлайна).
  ///
  /// Задачи без дедлайна расположены в конце.
  deadline,

  /// По времени дедлайна (сначала близкие к дедлайну).
  ///
  /// Задачи без дедлайна расположены в конце.
  deadlineAsc,
}
