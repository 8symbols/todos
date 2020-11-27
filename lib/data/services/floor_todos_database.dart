import 'dart:async';
import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:todos/data/daos/floor_branch_dao.dart';
import 'package:todos/data/daos/floor_todo_dao.dart';
import 'package:todos/data/daos/floor_todo_step_dao.dart';
import 'package:todos/data/daos/floor_todo_image_dao.dart';
import 'package:todos/data/entities/floor_branch.dart';
import 'package:todos/data/entities/floor_todo.dart';
import 'package:todos/data/entities/floor_todo_image.dart';
import 'package:todos/data/entities/floor_todo_step.dart';
import 'package:todos/data/mappers/branch_theme_converter.dart';
import 'package:todos/data/mappers/datetime_converter.dart';

part 'floor_todos_database.g.dart';

/// Хранилище задач в Floor.
@TypeConverters([
  DateTimeConverter,
  BranchThemeConverter,
])
@Database(
  version: 1,
  entities: [
    FloorBranch,
    FloorTodo,
    FloorTodoStep,
    FloorTodoImage,
  ],
)
abstract class FloorTodosDatabase extends FloorDatabase {
  /// DAO для работы с ветками.
  FloorBranchDao get branchDao;

  /// DAO для работы с задачами.
  FloorTodoDao get todoDao;

  /// DAO для работы с шагами задач.
  FloorTodoStepDao get todoStepDao;

  /// DAO для работы с изображениями задач.
  FloorTodoImageDao get todoImageDao;
}
