import 'package:flutter_test/flutter_test.dart';
import 'package:todos/data/repositories/todos_repository.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/presentation/constants/branch_themes.dart';

void main() {
  group('TodosRepository', () {
    FloorTodosDatabase database;
    TodosRepository repository;

    setUp(() async {
      database =
          await $FloorFloorTodosDatabase.inMemoryDatabaseBuilder().build();
      repository = TodosRepository(database);
    });

    tearDown(() async {
      await database.close();
    });

    test('изначально пуст', () async {
      expect((await repository.getBranches()).isEmpty, isTrue);
      expect((await repository.getTodos()).isEmpty, isTrue);
    });

    group('ветку', () {
      test('добавляет', () async {
        final branch = Branch('', BranchThemes.defaultBranchTheme);
        await repository.addBranch(branch);
        final branches = await repository.getBranches();
        expect(branches.length, 1);
        expect(branches.first.id, branch.id);
      });

      test('получает по id', () async {
        final branch = Branch('', BranchThemes.defaultBranchTheme);
        await repository.addBranch(branch);
        final gottenBranch = await repository.getBranch(branch.id);
        expect(branch.title, gottenBranch.title);
      });

      test('изменяет', () async {
        final branch = Branch('', BranchThemes.defaultBranchTheme);
        await repository.addBranch(branch);
        final editedBranch = branch.copyWith(title: 'edited');
        await repository.editBranch(editedBranch);
        final branches = await repository.getBranches();
        expect(branches.first.title, editedBranch.title);
      });

      test('удаляет', () async {
        final branch = Branch('', BranchThemes.defaultBranchTheme);
        await repository.addBranch(branch);
        await repository.deleteBranch(branch.id);
        expect((await repository.getBranches()).isEmpty, isTrue);
      });

      test('получает по задаче', () async {
        final branch1 = Branch('', BranchThemes.defaultBranchTheme);
        final branch2 = Branch('', BranchThemes.defaultBranchTheme);
        final todo1 = Todo('');
        final todo2 = Todo('');
        await repository.addBranch(branch1);
        await repository.addBranch(branch2);
        await repository.addTodo(branch1.id, todo1);
        await repository.addTodo(branch2.id, todo2);
        expect((await repository.getBranchOfTodo(todo1.id)).id, branch1.id);
        expect((await repository.getBranchOfTodo(todo2.id)).id, branch2.id);
      });
    });

    group('задачу', () {
      Branch branch;

      setUp(() async {
        branch = Branch('', BranchThemes.defaultBranchTheme);
        await repository.addBranch(branch);
      });

      tearDown(() async {
        await repository.deleteBranch(branch.id);
      });

      test('добавляет', () async {
        final todo = Todo('');
        await repository.addTodo(branch.id, todo);
        final todos = await repository.getTodos();
        expect(todos.length, 1);
        expect(todos.first.id, todo.id);
      });

      test('получает по id', () async {
        final todo = Todo('title');
        await repository.addTodo(branch.id, todo);
        final gottenTodo = await repository.getTodo(todo.id);
        expect(todo.title, gottenTodo.title);
      });

      test('получает из ветки', () async {
        final todo = Todo('');
        await repository.addTodo(branch.id, todo);
        final branch2 = Branch('', BranchThemes.defaultBranchTheme);
        await repository.addBranch(branch2);
        final todos = await repository.getTodos(branchId: branch.id);
        expect(todos.length, 1);
        expect(todos.first.id, todo.id);
        final todos2 = await repository.getTodos(branchId: branch2.id);
        expect(todos2.isEmpty, isTrue);
      });

      test('получает без ветки', () async {
        final todo = Todo('');
        final branch2 = Branch('', BranchThemes.defaultBranchTheme);
        final todo2 = Todo('');
        await repository.addTodo(branch.id, todo);
        await repository.addBranch(branch2);
        await repository.addTodo(branch2.id, todo2);
        final todos = await repository.getTodos();
        expect(todos.length, 2);
      });

      test('изменяет', () async {
        final todo = Todo('');
        await repository.addTodo(branch.id, todo);
        final editedTodo = todo.copyWith(title: 'edited');
        await repository.editTodo(editedTodo);
        final todos = await repository.getTodos();
        expect(todos.first.title, editedTodo.title);
      });

      test('удаляет', () async {
        final todo = Todo('');
        await repository.addTodo(branch.id, todo);
        await repository.deleteTodo(todo.id);
        expect((await repository.getTodos()).isEmpty, isTrue);
      });

      test('удаляет при удалении ветки', () async {
        final todo = Todo('');
        await repository.addTodo(branch.id, todo);
        await repository.deleteBranch(branch.id);
        expect((await repository.getTodos()).isEmpty, isTrue);
      });

      test('получает по шагу', () async {
        final todo1 = Todo('');
        final todo2 = Todo('');
        final step1 = TodoStep('');
        final step2 = TodoStep('');
        await repository.addTodo(branch.id, todo1);
        await repository.addTodo(branch.id, todo2);
        await repository.addTodoStep(todo1.id, step1);
        await repository.addTodoStep(todo2.id, step2);
        expect((await repository.getTodoOfStep(step1.id)).id, todo1.id);
        expect((await repository.getTodoOfStep(step2.id)).id, todo2.id);
      });
    });

    group('шаг задачи', () {
      Branch branch;
      Todo todo;

      setUp(() async {
        branch = Branch('', BranchThemes.defaultBranchTheme);
        todo = Todo('');
        await repository.addBranch(branch);
        await repository.addTodo(branch.id, todo);
      });

      tearDown(() async {
        await repository.deleteBranch(branch.id);
      });

      test('добавляет', () async {
        final step = TodoStep('');
        await repository.addTodoStep(todo.id, step);
        final steps = await repository.getStepsOfTodo(todo.id);
        expect(steps.length, 1);
        expect(steps.first.id, step.id);
      });

      test('получает по id', () async {
        final step = TodoStep('title');
        await repository.addTodoStep(todo.id, step);
        final gottenStep = await repository.getTodoStep(step.id);
        expect(step.title, gottenStep.title);
      });

      test('изменяет', () async {
        final step = TodoStep('');
        await repository.addTodoStep(todo.id, step);
        final editedStep = step.copyWith(title: 'edited');
        await repository.editTodoStep(editedStep);
        final steps = await repository.getStepsOfTodo(todo.id);
        expect(steps.first.title, editedStep.title);
      });

      test('удаляет', () async {
        final step = TodoStep('');
        await repository.addTodoStep(todo.id, step);
        await repository.deleteTodoStep(step.id);
        expect((await repository.getStepsOfTodo(todo.id)).isEmpty, isTrue);
      });

      test('удаляет при удалении задачи', () async {
        final step = TodoStep('');
        await repository.addTodoStep(todo.id, step);
        await repository.deleteTodo(todo.id);
        expect((await repository.getStepsOfTodo(todo.id)).isEmpty, isTrue);
      });
    });

    group('изображение задачи', () {
      Branch branch;
      Todo todo;

      setUp(() async {
        branch = Branch('', BranchThemes.defaultBranchTheme);
        todo = Todo('');
        await repository.addBranch(branch);
        await repository.addTodo(branch.id, todo);
      });

      tearDown(() async {
        await repository.deleteBranch(branch.id);
      });

      test('добавляет', () async {
        final image = 'path/to/image';
        await repository.addTodoImage(todo.id, image);
        final images = await repository.getImagesOfTodo(todo.id);
        expect(images.length, 1);
        expect(images.first, image);
      });

      test('удаляет', () async {
        final image = 'path/to/image';
        await repository.addTodoImage(todo.id, image);
        await repository.deleteTodoImage(todo.id, image);
        expect((await repository.getImagesOfTodo(todo.id)).isEmpty, isTrue);
      });

      test('удаляет при удалении задачи', () async {
        final image = 'path/to/image';
        await repository.addTodoImage(todo.id, image);
        await repository.deleteTodo(todo.id);
        expect((await repository.getImagesOfTodo(todo.id)).isEmpty, isTrue);
      });
    });
  });
}
