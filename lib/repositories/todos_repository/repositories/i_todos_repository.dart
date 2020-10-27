import 'package:todos/repositories/todos_repository/models/branch.dart';
import 'package:todos/repositories/todos_repository/models/image.dart';
import 'package:todos/repositories/todos_repository/models/step.dart';
import 'package:todos/repositories/todos_repository/models/todo.dart';

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

  Future<void> addStep(String todoId, Step step);

  Future<void> editStep(String stepId, Step step);

  Future<void> deleteStep(String stepId);

  Future<Step> getStep(String stepId);

  Future<List<Step>> getSteps({String todoId});

  Future<void> addImage(String todoId, Image image);

  Future<void> editImage(String imageId, Image image);

  Future<void> deleteImage(String imageId);

  Future<Image> getImage(String imageId);

  Future<List<Image>> getImages({String todoId});
}
