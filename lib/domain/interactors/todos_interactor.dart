import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
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
}
