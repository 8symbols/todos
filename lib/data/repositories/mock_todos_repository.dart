import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:uuid/uuid.dart';

class MockTodosRepository implements ITodosRepository {
  final _branches = <String, Branch>{};
  final _todos = <String, Todo>{};
  final _steps = <String, TodoStep>{};
  final _todosImages = <String, Set<String>>{};

  final _branchesTodos = <String, Set<String>>{};
  final _todosSteps = <String, Set<String>>{};

  MockTodosRepository() {
    prepopulateRepository();
  }

  void prepopulateRepository() {
    for (var i = 0; i < 3; ++i) {
      final id = Uuid().v4();
      final branch = Branch(id, id: id);
      addBranch(branch);
    }

    final branchesIds = _branches.keys.toList();
    for (var i = 0; i < 20; ++i) {
      final id = Uuid().v4();
      final todo = Todo(id, id: id);
      addTodo(branchesIds[i % branchesIds.length], todo);
    }

    final todosIds = _todos.keys.toList();
    for (var i = 0; i < 50; ++i) {
      final id = Uuid().v4();
      final step = TodoStep(id, id: id);
      addStep(todosIds[i % todosIds.length], step);
    }
  }

  @override
  Future<void> addBranch(Branch branch) async {
    _branches[branch.id] = branch;
    _branchesTodos[branch.id] = Set<String>();
  }

  @override
  Future<void> addImage(String todoId, String imagePath) async {
    _todosImages[todoId].add(imagePath);
  }

  @override
  Future<void> addStep(String todoId, TodoStep step) async {
    _steps[step.id] = step;
    _todosSteps[todoId].add(step.id);
  }

  @override
  Future<void> addTodo(String branchId, Todo todo) async {
    _todos[todo.id] = todo;
    _branchesTodos[branchId].add(todo.id);
    _todosSteps[todo.id] = Set<String>();
    _todosImages[todo.id] = Set<String>();
  }

  @override
  Future<void> deleteBranch(String branchId) async {
    _branches.remove(branchId);

    for (final todoId in _branchesTodos[branchId]) {
      _todos.remove(todoId);
    }
    _branchesTodos.remove(branchId);
  }

  @override
  Future<void> deleteImage(String todoId, String imagePath) async {
    _todosImages[todoId].remove(imagePath);
  }

  @override
  Future<void> deleteStep(String stepId) async {
    _steps.remove(stepId);
    for (final steps in _todosSteps.values) {
      steps.remove(stepId);
    }
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    _todos.remove(todoId);
    for (final todos in _branchesTodos.values) {
      todos.remove(todoId);
    }

    for (final stepId in _todosSteps[todoId]) {
      _steps.remove(stepId);
    }
    _todosSteps.remove(todoId);

    _todosImages.remove(todoId);
  }

  @override
  Future<void> editBranch(String branchId, Branch branch) async {
    _branches[branchId] = branch;
  }

  @override
  Future<void> editStep(String stepId, TodoStep step) async {
    _steps[stepId] = step;
  }

  @override
  Future<void> editTodo(String todoId, Todo todo) async {
    _todos[todoId] = todo;
  }

  @override
  Future<Branch> getBranch(String branchId) async {
    return _branches[branchId];
  }

  @override
  Future<List<Branch>> getBranches() async {
    return _branches.values.toList();
  }

  @override
  Future<List<String>> getImagesPaths(String todoId) async {
    return _todosImages[todoId].toList();
  }

  @override
  Future<TodoStep> getStep(String stepId) async {
    return _steps[stepId];
  }

  @override
  Future<List<TodoStep>> getSteps(String todoId) async {
    return _todosSteps[todoId].map((e) => _steps[e]).toList();
  }

  @override
  Future<Todo> getTodo(String todoId) async {
    return _todos[todoId];
  }

  @override
  Future<List<Todo>> getTodos({String branchId}) async {
    if (branchId == null) {
      return _todos.values.toList();
    }
    return _branchesTodos[branchId].map((e) => _todos[e]).toList();
  }
}
