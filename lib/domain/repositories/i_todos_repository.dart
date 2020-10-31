import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';

abstract class ITodosRepository {
  Future<void> addBranch(Branch branch);

  Future<void> editBranch(String branchId, Branch branch);

  Future<void> deleteBranch(String branchId);

  Future<Branch> getBranch(String branchId);

  Future<List<Branch>> getBranches();

  Future<void> addTodo(String branchId, Todo todo);

  Future<void> editTodo(String todoId, Todo todo);

  Future<void> deleteTodo(String todoId);

  Future<Todo> getTodo(String todoId);

  Future<List<Todo>> getTodos({String branchId});

  Future<void> addStep(String todoId, TodoStep step);

  Future<void> editStep(String stepId, TodoStep step);

  Future<void> deleteStep(String stepId);

  Future<TodoStep> getStep(String stepId);

  Future<List<TodoStep>> getSteps(String todoId);

  Future<void> addImage(String todoId, String imagePath);

  Future<void> deleteImage(String todoId, String imagePath);

  Future<List<String>> getImagesPaths(String todoId);
}
