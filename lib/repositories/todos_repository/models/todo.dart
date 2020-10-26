import 'package:meta/meta.dart';
import 'models.dart';
import 'task.dart';

class Todo {
  bool isFavorite;

  bool wasCompleted;

  String title;

  String notes;

  DateTime deadlineTime;

  DateTime notificationTime;

  DateTime creationTime;

  List<String> imagesPaths;

  List<Task> tasks;

  Priority priority;

  Theme theme;

  Todo({
    @required this.isFavorite,
    @required this.wasCompleted,
    @required this.title,
    @required this.notes,
    @required this.deadlineTime,
    @required this.notificationTime,
    @required this.creationTime,
    @required this.imagesPaths,
    @required this.tasks,
    @required this.priority,
    @required this.theme,
  });
}
