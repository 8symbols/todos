import 'package:flutter_test/flutter_test.dart';
import 'package:todos/data/entities/floor_branch.dart';
import 'package:todos/data/entities/floor_todo.dart';
import 'package:todos/data/entities/floor_todo_image.dart';
import 'package:todos/data/mappers/branch_mapper.dart';
import 'package:todos/data/mappers/todo_mapper.dart';
import 'package:todos/data/mappers/todo_step_mapper.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/presentation/constants/branch_themes.dart';

void main() {
  group('Хранилище задач Floor', () {
    FloorTodosDatabase database;

    setUp(() async {
      database =
          await $FloorFloorTodosDatabase.inMemoryDatabaseBuilder().build();
    });

    tearDown(() async {
      await database.close();
    });

    test('изначально пуст', () async {
      expect((await database.branchDao.findAllBranches()).isEmpty, isTrue);
      expect((await database.todoDao.findAllTodos()).isEmpty, isTrue);
    });

    group('ветку', () {
      test('добавляет', () async {
        final branch = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        await database.branchDao.insertBranch(branch);
        final branches = await database.branchDao.findAllBranches();
        expect(branches.length, 1);
        expect(branches.first.id, branch.id);
      });

      test('получает по id', () async {
        final branch = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        await database.branchDao.insertBranch(branch);
        final gottenBranch = await database.branchDao.findBranchById(branch.id);
        expect(branch.title, gottenBranch.title);
      });

      test('изменяет', () async {
        final baseBranch = Branch('', BranchThemes.defaultBranchTheme);
        final branch = BranchMapper.toFloorBranch(baseBranch);
        await database.branchDao.insertBranch(branch);
        final editedBranch =
            BranchMapper.toFloorBranch(baseBranch.copyWith(title: 'edited'));
        await database.branchDao.updateBranch(editedBranch);
        final branches = await database.branchDao.findAllBranches();
        expect(branches.first.title, editedBranch.title);
      });

      test('удаляет', () async {
        final branch = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        await database.branchDao.insertBranch(branch);
        await database.branchDao.deleteBranch(branch.id);
        expect((await database.branchDao.findAllBranches()).isEmpty, isTrue);
      });

      test('получает по задаче', () async {
        final branch1 = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        final branch2 = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        final todo1 = TodoMapper.toFloorTodo(branch1.id, Todo(''));
        final todo2 = TodoMapper.toFloorTodo(branch2.id, Todo(''));
        await database.branchDao.insertBranch(branch1);
        await database.branchDao.insertBranch(branch2);
        await database.todoDao.insertTodo(todo1);
        await database.todoDao.insertTodo(todo2);
        expect(
          (await database.todoDao.findBranchOfTodo(todo1.id)).id,
          branch1.id,
        );
        expect(
          (await database.todoDao.findBranchOfTodo(todo2.id)).id,
          branch2.id,
        );
      });
    });

    group('задачу', () {
      FloorBranch branch;

      setUp(() async {
        branch = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        await database.branchDao.insertBranch(branch);
      });

      tearDown(() async {
        await database.branchDao.deleteBranch(branch.id);
      });

      test('добавляет', () async {
        final todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.todoDao.insertTodo(todo);
        final todos = await database.todoDao.findAllTodos();
        expect(todos.length, 1);
        expect(todos.first.id, todo.id);
      });

      test('получает по id', () async {
        final todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.todoDao.insertTodo(todo);
        final gottenTodo = await database.todoDao.findTodoById(todo.id);
        expect(todo.title, gottenTodo.title);
      });

      test('получает из ветки', () async {
        final todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.todoDao.insertTodo(todo);
        final branch2 = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        await database.branchDao.insertBranch(branch2);
        final todos = await database.todoDao.findTodosOfBranch(branch.id);
        expect(todos.length, 1);
        expect(todos.first.id, todo.id);
        final todos2 = await database.todoDao.findTodosOfBranch(branch2.id);
        expect(todos2.isEmpty, isTrue);
      });

      test('получает без ветки', () async {
        final todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        final branch2 = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        final todo2 = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.todoDao.insertTodo(todo);
        await database.branchDao.insertBranch(branch2);
        await database.todoDao.insertTodo(todo2);
        final todos = await database.todoDao.findAllTodos();
        expect(todos.length, 2);
      });

      test('изменяет', () async {
        final baseTodo = Todo('');
        final todo = TodoMapper.toFloorTodo(branch.id, baseTodo);
        await database.todoDao.insertTodo(todo);
        final editedTodo = TodoMapper.toFloorTodo(
          branch.id,
          baseTodo.copyWith(title: 'edited'),
        );
        await database.todoDao.updateTodo(editedTodo);
        final todos = await database.todoDao.findAllTodos();
        expect(todos.first.title, editedTodo.title);
      });

      test('удаляет', () async {
        final todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.todoDao.insertTodo(todo);
        await database.todoDao.deleteTodo(todo.id);
        expect((await database.todoDao.findAllTodos()).isEmpty, isTrue);
      });

      test('удаляет при удалении ветки', () async {
        final todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.todoDao.insertTodo(todo);
        await database.branchDao.deleteBranch(branch.id);
        expect((await database.todoDao.findAllTodos()).isEmpty, isTrue);
      });

      test('получает по шагу', () async {
        final todo1 = TodoMapper.toFloorTodo(branch.id, Todo(''));
        final todo2 = TodoMapper.toFloorTodo(branch.id, Todo(''));
        final step1 = TodoStepMapper.toFloorTodoStep(todo1.id, TodoStep(''));
        final step2 = TodoStepMapper.toFloorTodoStep(todo2.id, TodoStep(''));
        await database.todoDao.insertTodo(todo1);
        await database.todoDao.insertTodo(todo2);
        await database.todoStepDao.insertStep(step1);
        await database.todoStepDao.insertStep(step2);
        expect(
          (await database.todoStepDao.findTodoOfStep(step1.id)).id,
          todo1.id,
        );
        expect(
          (await database.todoStepDao.findTodoOfStep(step2.id)).id,
          todo2.id,
        );
      });
    });

    group('шаг задачи', () {
      FloorBranch branch;
      FloorTodo todo;

      setUp(() async {
        branch = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.branchDao.insertBranch(branch);
        await database.todoDao.insertTodo(todo);
      });

      tearDown(() async {
        await database.branchDao.deleteBranch(branch.id);
      });

      test('добавляет', () async {
        final step = TodoStepMapper.toFloorTodoStep(todo.id, TodoStep(''));
        await database.todoStepDao.insertStep(step);
        final steps = await database.todoStepDao.findStepsOfTodo(todo.id);
        expect(steps.length, 1);
        expect(steps.first.id, step.id);
      });

      test('получает по id', () async {
        final step = TodoStepMapper.toFloorTodoStep(todo.id, TodoStep(''));
        await database.todoStepDao.insertStep(step);
        final gottenStep = await database.todoStepDao.findTodoStepById(step.id);
        expect(step.title, gottenStep.title);
      });

      test('изменяет', () async {
        final baseStep = TodoStep('');
        final step = TodoStepMapper.toFloorTodoStep(todo.id, baseStep);
        await database.todoStepDao.insertStep(step);
        final editedStep = TodoStepMapper.toFloorTodoStep(
          todo.id,
          baseStep.copyWith(title: 'edited'),
        );
        await database.todoStepDao.updateStep(editedStep);
        final steps = await database.todoStepDao.findStepsOfTodo(todo.id);
        expect(steps.first.title, editedStep.title);
      });

      test('удаляет', () async {
        final step = TodoStepMapper.toFloorTodoStep(todo.id, TodoStep(''));
        await database.todoStepDao.insertStep(step);
        await database.todoStepDao.deleteStep(step.id);
        expect(
          (await database.todoStepDao.findStepsOfTodo(todo.id)).isEmpty,
          isTrue,
        );
      });

      test('удаляет при удалении задачи', () async {
        final step = TodoStepMapper.toFloorTodoStep(todo.id, TodoStep(''));
        await database.todoStepDao.insertStep(step);
        await database.todoDao.deleteTodo(todo.id);
        expect(
          (await database.todoStepDao.findStepsOfTodo(todo.id)).isEmpty,
          isTrue,
        );
      });
    });

    group('изображение задачи', () {
      FloorBranch branch;
      FloorTodo todo;

      setUp(() async {
        branch = BranchMapper.toFloorBranch(
          Branch('', BranchThemes.defaultBranchTheme),
        );
        todo = TodoMapper.toFloorTodo(branch.id, Todo(''));
        await database.branchDao.insertBranch(branch);
        await database.todoDao.insertTodo(todo);
      });

      tearDown(() async {
        await database.branchDao.deleteBranch(branch.id);
      });

      test('добавляет', () async {
        final image = FloorTodoImage(todo.id, 'path/to/image');
        await database.todoImageDao.insertImage(image);
        final images = await database.todoImageDao.findImagesOfTodo(todo.id);
        expect(images.length, 1);
        expect(images.first.imagePath, image.imagePath);
      });

      test('удаляет', () async {
        final image = FloorTodoImage(todo.id, 'path/to/image');
        await database.todoImageDao.insertImage(image);
        await database.todoImageDao.deleteImage(image);
        expect(
          (await database.todoImageDao.findImagesOfTodo(todo.id)).isEmpty,
          isTrue,
        );
      });

      test('удаляет при удалении задачи', () async {
        final image = FloorTodoImage(todo.id, 'path/to/image');
        await database.todoImageDao.insertImage(image);
        await database.todoDao.deleteTodo(todo.id);
        expect(
          (await database.todoImageDao.findImagesOfTodo(todo.id)).isEmpty,
          isTrue,
        );
      });
    });
  });
}
