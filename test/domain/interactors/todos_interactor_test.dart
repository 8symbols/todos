import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branches_sort_order.dart';
import 'package:todos/domain/models/branches_view_settings.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/models/todos_sort_order.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';
import 'package:todos/presentation/constants/branch_themes.dart';

class MockTodosRepository extends Mock implements ITodosRepository {}

class MockNotificationService extends Mock implements INotificationsService {}

void main() {
  group('TodosInteractor', () {
    ITodosRepository repository;
    INotificationsService notificationsService;
    TodosInteractor interactor;

    setUp(() {
      repository = MockTodosRepository();
      notificationsService = MockNotificationService();
      interactor = TodosInteractor(
        repository,
        notificationsService: notificationsService,
      );
    });

    test('добавляет ветку', () async {
      await interactor.addBranch(Branch('', BranchThemes.defaultBranchTheme));
      verify(repository.addBranch(any));
    });

    test('изменяет ветку', () async {
      await interactor.editBranch(Branch('', BranchThemes.defaultBranchTheme));
      verify(repository.editBranch(any));
    });

    test('удаляет ветку', () async {
      when(repository.getTodos(branchId: anyNamed('branchId')))
          .thenAnswer((_) async => []);
      await interactor.deleteBranch('');
      verify(repository.deleteBranch(any));
    });

    test('получает ветку', () async {
      await interactor.getBranch('');
      verify(repository.getBranch(any));
    });

    test('получает ветки', () async {
      await interactor.getBranches();
      verify(repository.getBranches());
    });

    test('добавляет задачу', () async {
      await interactor.addTodo('', Todo(''));
      verify(repository.addTodo(any, any));
    });

    test('изменяет задачу', () async {
      when(interactor.getTodo(any)).thenAnswer((_) async => Todo(''));
      await interactor.editTodo(Todo(''));
      verify(repository.editTodo(any));
    });

    test('удаляет задачу', () async {
      when(interactor.getTodo(any)).thenAnswer((_) async => Todo(''));
      when(interactor.getImagesOfTodo(any)).thenAnswer((_) async => []);
      await interactor.deleteTodo('');
      verify(repository.deleteTodo(any));
    });

    test('получает задачу', () async {
      await interactor.getTodo('');
      verify(repository.getTodo(any));
    });

    test('получает задачи', () async {
      await interactor.getTodos();
      verify(repository.getTodos());
    });

    test('добавляет шаг задачи', () async {
      await interactor.addTodoStep('', TodoStep(''));
      verify(repository.addTodoStep(any, any));
    });

    test('изменяет шаг задачи', () async {
      await interactor.editTodoStep(TodoStep(''));
      verify(repository.editTodoStep(any));
    });

    test('удаляет шаг задачи', () async {
      await interactor.deleteTodoStep('');
      verify(repository.deleteTodoStep(any));
    });

    test('получает шаг задачи', () async {
      await interactor.getTodoStep('');
      verify(repository.getTodoStep(any));
    });

    test('получает шаги задачи', () async {
      await interactor.getStepsOfTodo('');
      verify(repository.getStepsOfTodo(any));
    });

    test('добавляет изображение задачи', () async {
      expect(
        () async => await interactor.addTodoImage('', ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('удаляет изображение задачи', () async {
      await interactor.deleteTodoImage('', '', isRestorable: true);
      verify(repository.deleteTodoImage(any, any));
    });

    test('получает изображения задачи', () async {
      await interactor.getImagesOfTodo('');
      verify(repository.getImagesOfTodo(any));
    });

    test('получает ветку задачи', () async {
      await interactor.getBranchOfTodo('');
      verify(repository.getBranchOfTodo(any));
    });

    test('получает задачу по шагу', () async {
      await interactor.getTodoOfStep('');
      verify(repository.getTodoOfStep(any));
    });

    test('применяет настройки отображения к списку задач', () async {
      final todos = [
        Todo(''),
        Todo('', isFavorite: true),
        Todo('', wasCompleted: true),
        Todo('', isFavorite: true, wasCompleted: true),
        Todo(''),
        Todo(''),
      ];

      const settings = TodosViewSettings(
        areCompletedTodosVisible: false,
        areNonFavoriteTodosVisible: false,
        sortOrder: TodosSortOrder.creationAsc,
      );

      final appliedTodos = interactor.applyTodosViewSettings(todos, settings);

      for (final todo in appliedTodos) {
        expect(
          todo.wasCompleted && !settings.areCompletedTodosVisible,
          isFalse,
        );
        expect(
          !todo.isFavorite && !settings.areNonFavoriteTodosVisible,
          isFalse,
        );
      }

      for (var i = 1; i < appliedTodos.length; ++i) {
        final previous = appliedTodos[i - 1].creationTime;
        final current = appliedTodos[i].creationTime;
        expect(
          previous.isBefore(current) || previous.isAtSameMomentAs(current),
          isTrue,
        );
      }
    });

    test('применяет настройки отображения к списку веток', () async {
      final branches = [
        Branch('a', BranchThemes.defaultBranchTheme),
        Branch('c', BranchThemes.defaultBranchTheme),
        Branch('b', BranchThemes.defaultBranchTheme),
      ];

      const settings = BranchesViewSettings(
        sortOrder: BranchesSortOrder.titleAsc,
      );

      final appliedBranches =
          interactor.applyBranchesViewSettings(branches, settings);

      for (var i = 1; i < appliedBranches.length; ++i) {
        final previous = appliedBranches[i - 1].title;
        final current = appliedBranches[i].title;
        expect(previous.compareTo(current) <= 0, isTrue);
      }
    });
  });
}
