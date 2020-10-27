import 'package:todos/data/repositories/todos_repository/models/todo.dart';
import 'package:todos/data/repositories/todos_repository/repositories/i_todos_repository.dart';

class TodosInteractor {
  final ITodosRepository _repository;

  TodosInteractor(this._repository);

  Future<void> addTodo(String branchId, Todo todo) async {
    return _repository.addTodo(branchId, todo);
  }

  Future<void> editTodo(String todoId, Todo todo) async {
    return _repository.editTodo(todoId, todo);
  }

  Future<void> deleteTodo(String todoId) {
    return _repository.deleteTodo(todoId);
  }

  Future<Todo> getTodo(String todoId) {
    return _repository.getTodo(todoId);
  }

  Future<List<Todo>> getTodos({String branchId}) {
    return _repository.getTodos(branchId: branchId);
  }
}
