import 'package:todos/data/services/notifications_service.dart';
import 'package:todos/domain/factories/branches_comparators_factory.dart';
import 'package:todos/domain/factories/todos_comparators_factory.dart';
import 'package:todos/domain/models/branches_sort_order.dart';
import 'package:todos/domain/models/todo_list_view_settings.dart';
import 'package:todos/domain/utils/filesystem_utils.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/models/todos_sort_order.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';
import 'package:todos/domain/wrappers/nullable.dart';

/// Интерактор для взаимодействия с задачами.
class TodosInteractor {
  /// Хранилище задач.
  final ITodosRepository repository;

  /// Сервис для работы с уведомлениями.
  final INotificationsService notificationsService;

  const TodosInteractor(
    this.repository, {
    this.notificationsService = const NotificationsService(),
  });

  /// Добавляет ветку задач [branch].
  Future<void> addBranch(Branch branch) async {
    return repository.addBranch(branch);
  }

  /// Устанавливает ветке с идентификатором [branch.id] значения
  /// остальных полей [branch].
  Future<void> editBranch(Branch branch) async {
    return repository.editBranch(branch);
  }

  /// Удаляет ветку с идентификатором [branchId].
  ///
  /// Связанные с ней задачи также удаляются.
  Future<void> deleteBranch(String branchId) async {
    final todos = await getTodos(branchId: branchId);
    for (final todo in todos) {
      await deleteTodo(todo.id);
    }
    return repository.deleteBranch(branchId);
  }

  /// Получает ветку с идентификатором [branchId].
  Future<Branch> getBranch(String branchId) async {
    return repository.getBranch(branchId);
  }

  /// Получает все ветки.
  Future<List<Branch>> getBranches() async {
    return repository.getBranches();
  }

  /// Добавляет задачу [todo] в ветку c идентификатором [branchId].
  ///
  /// Устанавливает уведомление, если задано [todo.notificationTime].
  /// Если задано [todo.mainImagePath], копирует картинку в локальную
  /// директорию и устанавливает в [todo.mainImagePath] путь на копию.
  Future<void> addTodo(String branchId, Todo todo) async {
    if (todo.notificationTime != null) {
      await notificationsService.scheduleNotification(todo);
    }
    if (todo.mainImagePath != null) {
      final newPath = await FileSystemUtils.copyToLocal(todo.mainImagePath);
      todo = todo.copyWith(mainImagePath: Nullable(newPath));
    }
    return repository.addTodo(branchId, todo);
  }

  /// Устанавливает задаче с идентификатором [todo.id] значения
  /// остальных полей [todo].
  ///
  /// В случае изменения [todo.notificationTime] удаляет предыдущее уведомление
  /// и устанавливает новое.
  /// В случае изменения [todo.mainImagePath] удаляет предыдущее изображение,
  /// копирует новое в локальную директорию и устанавливает в
  /// [todo.mainImagePath] путь на копию.
  Future<void> editTodo(Todo todo) async {
    final oldTodo = await getTodo(todo.id);
    await _handleNotifications(oldTodo, todo);
    todo = await _handleMainImages(oldTodo, todo);
    return repository.editTodo(todo);
  }

  /// Удаляет предыдущее уведомление и устанавливает новое, если необходимо.
  Future<void> _handleNotifications(Todo oldTodo, Todo newTodo) async {
    if (oldTodo.notificationTime == null && newTodo.notificationTime != null) {
      await notificationsService.scheduleNotification(newTodo);
    } else if (oldTodo.notificationTime != null &&
        newTodo.notificationTime == null) {
      await notificationsService.cancelNotification(oldTodo);
    } else if (oldTodo.notificationTime != null &&
        newTodo.notificationTime != null) {
      if (!oldTodo.notificationTime
          .isAtSameMomentAs(newTodo.notificationTime)) {
        await notificationsService.cancelNotification(oldTodo);
        await notificationsService.scheduleNotification(newTodo);
      }
    }
  }

  /// Удаляет предыдущее изображение и копирует новое, если необходимо.
  ///
  /// Возвращает [newTodo]. Если копирует новое изображение, то устанавливает
  /// в [newTodo.mainImagePath] путь к нему.
  Future<Todo> _handleMainImages(Todo oldTodo, Todo newTodo) async {
    if (oldTodo.mainImagePath != newTodo.mainImagePath) {
      if (oldTodo.mainImagePath != null) {
        await FileSystemUtils.deleteFile(oldTodo.mainImagePath);
      }
      if (newTodo.mainImagePath != null) {
        final newPath =
            await FileSystemUtils.copyToLocal(newTodo.mainImagePath);
        newTodo = newTodo.copyWith(mainImagePath: Nullable(newPath));
      }
    }
    return newTodo;
  }

  /// Удаляет задачу с идентификатором [todoId].
  ///
  /// Связанные с ней пункты, уведомления и изображения также удаляются.
  Future<void> deleteTodo(String todoId) async {
    final todo = await getTodo(todoId);
    if (todo.notificationTime != null) {
      await notificationsService.cancelNotification(todo);
    }
    if (todo.mainImagePath != null) {
      await FileSystemUtils.deleteFile(todo.mainImagePath);
    }
    final imagesPaths = await getImagesOfTodo(todoId);
    for (final imagePath in imagesPaths) {
      await deleteTodoImage(todoId, imagePath);
    }
    return repository.deleteTodo(todoId);
  }

  /// Получает задачу с идентификатором [todoId].
  Future<Todo> getTodo(String todoId) async {
    return repository.getTodo(todoId);
  }

  /// Получает все задачи из ветки с идентификатором [branchId].
  ///
  /// Если [branchId] не задан, получает задачи из всех веток.
  Future<List<Todo>> getTodos({String branchId}) async {
    return repository.getTodos(branchId: branchId);
  }

  /// Добавляет пункт [step] в задачу c идентификатором [todoId].
  Future<void> addTodoStep(String todoId, TodoStep step) async {
    return repository.addTodoStep(todoId, step);
  }

  /// Устанавливает пункту с идентификатором [step.id] значения
  /// остальных полей [step].
  Future<void> editTodoStep(TodoStep step) async {
    return repository.editTodoStep(step);
  }

  /// Удаляет пункт с идентификатором [stepId].
  Future<void> deleteTodoStep(String stepId) async {
    return repository.deleteTodoStep(stepId);
  }

  /// Получает пункт с идентификатором [stepId].
  Future<TodoStep> getTodoStep(String stepId) async {
    return repository.getTodoStep(stepId);
  }

  /// Получает все пункты задачи с идентификатором [todoId].
  Future<List<TodoStep>> getStepsOfTodo(String todoId) async {
    return repository.getStepsOfTodo(todoId);
  }

  /// Копирует картинку по пути [tmpImagePath] в локальную директорию и
  /// и добавляет путь к копии в задачу c идентификатором [todoId].
  Future<void> addTodoImage(String todoId, String tmpImagePath) async {
    final imagePath = await FileSystemUtils.copyToLocal(tmpImagePath);
    return repository.addTodoImage(todoId, imagePath);
  }

  /// Удаляет путь к изображению [imagePath] из задачи
  /// c идентификатором [todoId], а также само изображение.
  Future<void> deleteTodoImage(String todoId, String imagePath) async {
    await FileSystemUtils.deleteFile(imagePath);
    return repository.deleteTodoImage(todoId, imagePath);
  }

  /// Получает все пути к изображениям задачи с идентификатором [todoId].
  Future<List<String>> getImagesOfTodo(String todoId) async {
    return repository.getImagesOfTodo(todoId);
  }

  /// Возвращает ветку, которой принадлжеит задача с идентификатором
  /// [todoId].
  Future<Branch> getBranchOfTodo(String todoId) async {
    return repository.getBranchOfTodo(todoId);
  }

  /// Возвращает задачу, которой принадлежит шаг с идентификатором
  /// [stepId].
  Future<Todo> getTodoOfStep(String stepId) async {
    return repository.getTodoOfStep(stepId);
  }

  /// Сортирует задачи [todos] в соответствии с порядком сортировки
  /// [sortOrder].
  void sortTodos(List<Todo> todos, TodosSortOrder sortOrder) {
    todos.sort(TodosComparatorsFactory.getComparator(sortOrder));
  }

  /// Сортирует ветки [branches] в соответствии с порядком сортировки
  /// [sortOrder].
  void sortBranches(List<Branch> branches, BranchesSortOrder sortOrder) {
    branches.sort(BranchesComparatorsFactory.getComparator(sortOrder));
  }

  /// Создает новый список на основе [todos] и применяет к нему
  /// насройки отображения [viewSettings].
  List<Todo> applyViewSettings(
    List<Todo> todos,
    TodoListViewSettings viewSettings,
  ) {
    final oldTodos = todos;

    if (!viewSettings.areCompletedTodosVisible) {
      todos = todos.where((todo) => !todo.wasCompleted).toList();
    }

    if (!viewSettings.areNonFavoriteTodosVisible) {
      todos = todos.where((todo) => todo.isFavorite).toList();
    }

    if (identical(todos, oldTodos)) {
      todos = List<Todo>.from(todos);
    }

    sortTodos(todos, viewSettings.sortOrder);
    return todos;
  }

  /// Удаляет завершенные задачи в ветке с идентификатором [branchId].
  ///
  /// Если идентификатор не указан, удаляет завершенные задачи из всех веток.
  Future<void> deleteCompletedTodos({String branchId}) async {
    List<Todo> todos = await getTodos(branchId: branchId);
    for (final todo in todos) {
      if (todo.wasCompleted) {
        await deleteTodo(todo.id);
      }
    }
  }
}
