import 'package:todos/data/entities/floor_todo_image.dart';
import 'package:todos/data/mappers/branch_mapper.dart';
import 'package:todos/data/mappers/todo_mapper.dart';
import 'package:todos/data/mappers/todo_step_mapper.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';

/// Хранилище задач.
class TodosRepository implements ITodosRepository {
  /// Хранилище задач в Floor.
  final FloorTodosDatabase _floorTodosDatabase;

  const TodosRepository(this._floorTodosDatabase);

  @override
  Future<void> addBranch(Branch branch) async {
    final floorBranch = BranchMapper.toFloorBranch(branch);
    await _floorTodosDatabase.branchDao.insertBranch(floorBranch);
  }

  @override
  Future<void> addTodo(String branchId, Todo todo) async {
    final floorTodo = TodoMapper.toFloorTodo(branchId, todo);
    await _floorTodosDatabase.todoDao.insertTodo(floorTodo);
  }

  @override
  Future<void> addTodoImage(String todoId, String imagePath) async {
    final floorImage = FloorTodoImage(todoId, imagePath);
    await _floorTodosDatabase.todoImageDao.insertImage(floorImage);
  }

  @override
  Future<void> addTodoStep(String todoId, TodoStep step) async {
    final floorTodoStep = TodoStepMapper.toFloorTodoStep(todoId, step);
    await _floorTodosDatabase.todoStepDao.insertStep(floorTodoStep);
  }

  @override
  Future<void> deleteBranch(String branchId) async {
    await _floorTodosDatabase.branchDao.deleteBranch(branchId);
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _floorTodosDatabase.todoDao.deleteTodo(todoId);
  }

  @override
  Future<void> deleteTodoImage(String todoId, String imagePath) async {
    final floorImage = FloorTodoImage(todoId, imagePath);
    await _floorTodosDatabase.todoImageDao.deleteImage(floorImage);
  }

  @override
  Future<void> deleteTodoStep(String stepId) async {
    await _floorTodosDatabase.todoStepDao.deleteStep(stepId);
  }

  @override
  Future<void> editBranch(Branch branch) async {
    final floorBranch = BranchMapper.toFloorBranch(branch);
    await _floorTodosDatabase.branchDao.updateBranch(floorBranch);
  }

  @override
  Future<void> editTodo(Todo todo) async {
    final branchOfTodo =
        await _floorTodosDatabase.todoDao.findBranchOfTodo(todo.id);
    final floorTodo = TodoMapper.toFloorTodo(branchOfTodo.id, todo);
    await _floorTodosDatabase.todoDao.updateTodo(floorTodo);
  }

  @override
  Future<void> editTodoStep(TodoStep step) async {
    final todoOfStep =
        await _floorTodosDatabase.todoStepDao.findTodoOfStep(step.id);
    final floorTodoStep = TodoStepMapper.toFloorTodoStep(todoOfStep.id, step);
    await _floorTodosDatabase.todoStepDao.updateStep(floorTodoStep);
  }

  @override
  Future<Branch> getBranch(String branchId) async {
    final floorBranch =
        await _floorTodosDatabase.branchDao.findBranchById(branchId);
    return BranchMapper.fromFloorBranch(floorBranch);
  }

  @override
  Future<List<Branch>> getBranches() async {
    final floorBranches = await _floorTodosDatabase.branchDao.findAllBranches();
    return floorBranches
        .map((floorBranch) => BranchMapper.fromFloorBranch(floorBranch))
        .toList();
  }

  @override
  Future<Todo> getTodo(String todoId) async {
    final floorTodo = await _floorTodosDatabase.todoDao.findTodoById(todoId);
    return TodoMapper.fromFloorTodo(floorTodo);
  }

  @override
  Future<List<String>> getImagesOfTodo(String todoId) async {
    final floorImages =
        await _floorTodosDatabase.todoImageDao.findImagesOfTodo(todoId);
    return floorImages.map((floorImage) => floorImage.imagePath).toList();
  }

  @override
  Future<TodoStep> getTodoStep(String stepId) async {
    final floorTodoStep =
        await _floorTodosDatabase.todoStepDao.findTodoStepById(stepId);
    return TodoStepMapper.fromFloorTodoStep(floorTodoStep);
  }

  @override
  Future<List<TodoStep>> getStepsOfTodo(String todoId) async {
    final floorTodoSteps =
        await _floorTodosDatabase.todoStepDao.findStepsOfTodo(todoId);
    return floorTodoSteps
        .map((floorTodoStep) => TodoStepMapper.fromFloorTodoStep(floorTodoStep))
        .toList();
  }

  @override
  Future<List<Todo>> getTodos({String branchId}) async {
    final floorTodos = branchId != null
        ? await _floorTodosDatabase.todoDao.findTodosOfBranch(branchId)
        : await _floorTodosDatabase.todoDao.findAllTodos();
    return floorTodos
        .map((floorTodo) => TodoMapper.fromFloorTodo(floorTodo))
        .toList();
  }

  @override
  Future<Branch> getBranchOfTodo(String todoId) async {
    final floorBranch =
        await _floorTodosDatabase.todoDao.findBranchOfTodo(todoId);
    return BranchMapper.fromFloorBranch(floorBranch);
  }

  @override
  Future<Todo> getTodoOfStep(String stepId) async {
    final floorTodo =
        await _floorTodosDatabase.todoStepDao.findTodoOfStep(stepId);
    return TodoMapper.fromFloorTodo(floorTodo);
  }
}
