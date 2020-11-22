import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';

/// Хранилище задач, их веток, пунктов и изображений.
abstract class ITodosRepository {
  /// Добавляет ветку задач [branch].
  Future<void> addBranch(Branch branch);

  /// Устанавливает ветке с идентификатором [branch.id] значения
  /// остальных полей [branch].
  Future<void> editBranch(Branch branch);

  /// Удаляет ветку с идентификатором [branchId].
  ///
  /// Связанные с ней задачи также удаляются.
  Future<void> deleteBranch(String branchId);

  /// Получает ветку с идентификатором [branchId].
  Future<Branch> getBranch(String branchId);

  /// Получает все ветки.
  Future<List<Branch>> getBranches();

  /// Добавляет задачу [todo] в ветку c идентификатором [branchId].
  Future<void> addTodo(String branchId, Todo todo);

  /// Устанавливает задаче с идентификатором [todo.id] значения
  /// остальных полей [todo].
  Future<void> editTodo(Todo todo);

  /// Удаляет задачу с идентификатором [todoId].
  ///
  /// Связанные с ней пункты и изображения также удаляются.
  Future<void> deleteTodo(String todoId);

  /// Получает задачу с идентификатором [todoId].
  Future<Todo> getTodo(String todoId);

  /// Получает все задачи из ветки с идентификатором [branchId].
  ///
  /// Если [branchId] не задан, получает задачи из всех веток.
  Future<List<Todo>> getTodos({String branchId});

  /// Добавляет пункт [step] в задачу c идентификатором [todoId].
  Future<void> addTodoStep(String todoId, TodoStep step);

  /// Устанавливает пункту с идентификатором [step.id] значения
  /// остальных полей [step].
  Future<void> editTodoStep(TodoStep step);

  /// Удаляет пункт с идентификатором [stepId].
  Future<void> deleteTodoStep(String stepId);

  /// Получает пункт с идентификатором [stepId].
  Future<TodoStep> getTodoStep(String stepId);

  /// Получает все пункты задачи с идентификатором [todoId].
  Future<List<TodoStep>> getStepsOfTodo(String todoId);

  /// Добавляет путь к изображению [imagePath] в задачу
  /// c идентификатором [todoId].
  Future<void> addTodoImage(String todoId, String imagePath);

  /// Удаляет путь к изображению [imagePath] из задачи
  /// c идентификатором [todoId].
  Future<void> deleteTodoImage(String todoId, String imagePath);

  /// Получает все пути к изображениям задачи с идентификатором [todoId].
  Future<List<String>> getImagesOfTodo(String todoId);

  /// Возвращает ветку, которой принадлежит задача с идентификатором
  /// [todoId].
  Future<Branch> getBranchOfTodo(String todoId);

  /// Возвращает задачу, которой принадлежит шаг с идентификатором
  /// [stepId].
  Future<Todo> getTodoOfStep(String stepId);
}
