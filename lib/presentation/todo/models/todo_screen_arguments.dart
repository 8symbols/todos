import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/models/todo.dart';

/// Аргументы экрана задачи.
class TodoScreenArguments {
  /// Тема ветки.
  final BranchTheme branchTheme;

  /// Задача.
  final Todo todo;

  const TodoScreenArguments(this.branchTheme, this.todo);
}
