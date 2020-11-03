import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

/// Интерактор для взаимодействия с задачами.
class TodosInteractor {
  /// Хранилище задач.
  final ITodosRepository _repository;

  TodosInteractor(this._repository);

  /// Добавляет ветку задач [branch].
  Future<void> addBranch(Branch branch) {
    return _repository.addBranch(branch);
  }

  /// Устанавливает ветке с идентификатором [branch.id] значения
  /// остальных полей [branch].
  Future<void> editBranch(Branch branch) {
    return _repository.editBranch(branch);
  }

  /// Получает все ветки.
  Future<List<Branch>> getBranches() {
    return _repository.getBranches();
  }

  /// Добавляет задачу [todo] в ветку c идентификатором [branchId].
  Future<void> addTodo(String branchId, Todo todo) async {
    return _repository.addTodo(branchId, todo);
  }

  /// Устанавливает задаче с идентификатором [todo.id] значения
  /// остальных полей [todo].
  Future<void> editTodo(Todo todo) async {
    return _repository.editTodo(todo);
  }

  /// Удаляет задачу с идентификатором [todoId].
  ///
  /// Связанные с ней пункты и изображения также удаляются.
  Future<void> deleteTodo(String todoId) {
    return _repository.deleteTodo(todoId);
  }

  /// Получает задачу с идентификатором [todoId].
  Future<Todo> getTodo(String todoId) {
    return _repository.getTodo(todoId);
  }

  /// Получает все задачи из ветки с идентификатором [branchId].
  ///
  /// Если [branchId] не задан, получает задачи из всех веток.
  Future<List<Todo>> getTodos({String branchId}) {
    return _repository.getTodos(branchId: branchId);
  }

  /// Добавляет пункт [step] в задачу c идентификатором [todoId].
  Future<void> addStep(String todoId, TodoStep step) {
    return _repository.addStep(todoId, step);
  }

  /// Устанавливает пункту с идентификатором [step.id] значения
  /// остальных полей [step].
  Future<void> editStep(TodoStep step) {
    return _repository.editStep(step);
  }

  /// Удаляет пункт с идентификатором [stepId].
  Future<void> deleteStep(String stepId) {
    return _repository.deleteStep(stepId);
  }

  /// Получает все пункты задачи с идентификатором [todoId].
  Future<List<TodoStep>> getSteps(String todoId) {
    return _repository.getSteps(todoId);
  }
}
