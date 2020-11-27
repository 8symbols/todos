import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:meta/meta.dart';

/// Хранит всю информацию о задаче.
class TodoData {
  /// Ветка задачи.
  final String branchId;

  /// Задача.
  final Todo todo;

  /// Шаги задачи.
  final List<TodoStep> todoSteps;

  /// Пути к изображениям задачи.
  final List<String> todoImages;

  const TodoData({
    @required this.branchId,
    @required this.todo,
    @required this.todoSteps,
    @required this.todoImages,
  });
}
