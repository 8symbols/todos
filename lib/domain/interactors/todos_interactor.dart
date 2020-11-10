import 'package:todos/domain/factories/todos_comparators_factory.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/models/todo_step.dart';
import 'package:todos/domain/models/todos_sort_order.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_notifications_service.dart';

/// Интерактор для взаимодействия с задачами.
class TodosInteractor {
  /// Хранилище задач.
  final ITodosRepository _repository;

  /// Сервис для работы с уведомлениями.
  final INotificationsService _notificationsService;

  TodosInteractor(this._repository, this._notificationsService);

  /// Добавляет ветку задач [branch].
  Future<void> addBranch(Branch branch) async {
    return _repository.addBranch(branch);
  }

  /// Устанавливает ветке с идентификатором [branch.id] значения
  /// остальных полей [branch].
  Future<void> editBranch(Branch branch) async {
    return _repository.editBranch(branch);
  }

  /// Удаляет ветку с идентификатором [branchId].
  ///
  /// Связанные с ней задачи также удаляются.
  Future<void> deleteBranch(String branchId) async {
    return _repository.deleteBranch(branchId);
  }

  /// Получает ветку с идентификатором [branchId].
  Future<Branch> getBranch(String branchId) async {
    return _repository.getBranch(branchId);
  }

  /// Получает все ветки.
  Future<List<Branch>> getBranches() async {
    return _repository.getBranches();
  }

  /// Добавляет задачу [todo] в ветку c идентификатором [branchId].
  Future<void> addTodo(String branchId, Todo todo) async {
    return _repository.addTodo(branchId, todo);
  }

  /// Устанавливает задаче с идентификатором [todo.id] значения
  /// остальных полей [todo].
  ///
  /// В случае изменения [todo.notificationTime] удаляет предыдущее уведомление.
  /// В случае изменения [todo.themeImagePath] удаляет предыдущее изображение.
  Future<void> editTodo(Todo todo) async {
    final oldTodo = await getTodo(todo.id);
    await _handleNotifications(oldTodo, todo);
    return _repository.editTodo(todo);
  }

  /// Удаляет предыдущее уведомление и устанавливает новое, если необходимо.
  Future<void> _handleNotifications(Todo oldTodo, Todo newTodo) async {
    if (oldTodo.notificationTime == null && newTodo.notificationTime != null) {
      await _notificationsService.scheduleNotification(newTodo);
    } else if (oldTodo.notificationTime != null &&
        newTodo.notificationTime == null) {
      await _notificationsService.cancelNotification(oldTodo);
    } else if (oldTodo.notificationTime != null &&
        newTodo.notificationTime != null) {
      if (!oldTodo.notificationTime
          .isAtSameMomentAs(newTodo.notificationTime)) {
        await _notificationsService.cancelNotification(oldTodo);
        await _notificationsService.scheduleNotification(newTodo);
      }
    }
  }

  /// Удаляет задачу с идентификатором [todoId].
  ///
  /// Связанные с ней пункты, уведомления и изображения также удаляются.
  Future<void> deleteTodo(String todoId) async {
    final todo = await getTodo(todoId);
    if (todo.notificationTime != null) {
      await _notificationsService.cancelNotification(todo);
    }
    return _repository.deleteTodo(todoId);
  }

  /// Получает задачу с идентификатором [todoId].
  Future<Todo> getTodo(String todoId) async {
    return _repository.getTodo(todoId);
  }

  /// Получает все задачи из ветки с идентификатором [branchId].
  ///
  /// Если [branchId] не задан, получает задачи из всех веток.
  Future<List<Todo>> getTodos({String branchId}) async {
    return _repository.getTodos(branchId: branchId);
  }

  /// Добавляет пункт [step] в задачу c идентификатором [todoId].
  Future<void> addStep(String todoId, TodoStep step) async {
    return _repository.addStep(todoId, step);
  }

  /// Устанавливает пункту с идентификатором [step.id] значения
  /// остальных полей [step].
  Future<void> editStep(TodoStep step) async {
    return _repository.editStep(step);
  }

  /// Удаляет пункт с идентификатором [stepId].
  Future<void> deleteStep(String stepId) async {
    return _repository.deleteStep(stepId);
  }

  /// Получает пункт с идентификатором [stepId].
  Future<TodoStep> getStep(String stepId) async {
    return _repository.getStep(stepId);
  }

  /// Получает все пункты задачи с идентификатором [todoId].
  Future<List<TodoStep>> getSteps(String todoId) async {
    return _repository.getSteps(todoId);
  }

  /// Добавляет путь к изображению [imagePath] в задачу
  /// c идентификатором [todoId].
  Future<void> addImagePath(String todoId, String imagePath) async {
    return _repository.addImagePath(todoId, imagePath);
  }

  /// Удаляет путь к изображению [imagePath] из задачи
  /// c идентификатором [todoId].
  Future<void> deleteImagePath(String todoId, String imagePath) async {
    return _repository.deleteImagePath(todoId, imagePath);
  }

  /// Получает все пути к изображениям задачи с идентификатором [todoId].
  Future<List<String>> getImagesPaths(String todoId) async {
    return _repository.getImagesPaths(todoId);
  }

  /// Сортирует задачи [todos] в соответствии с порядком сортировки [sortOrder].
  void sortTodos(List<Todo> todos, TodosSortOrder sortOrder) {
    todos.sort(TodosComparatorsFactory.getComparator(sortOrder));
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
