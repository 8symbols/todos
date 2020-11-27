// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_todos_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorFloorTodosDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FloorTodosDatabaseBuilder databaseBuilder(String name) =>
      _$FloorTodosDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FloorTodosDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FloorTodosDatabaseBuilder(null);
}

class _$FloorTodosDatabaseBuilder {
  _$FloorTodosDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$FloorTodosDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FloorTodosDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FloorTodosDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$FloorTodosDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FloorTodosDatabase extends FloorTodosDatabase {
  _$FloorTodosDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FloorBranchDao _branchDaoInstance;

  FloorTodoDao _todoDaoInstance;

  FloorTodoStepDao _todoStepDaoInstance;

  FloorTodoImageDao _todoImageDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `branches` (`id` TEXT NOT NULL, `title` TEXT NOT NULL, `branch_theme` BLOB NOT NULL, `last_usage_time` INTEGER NOT NULL, `creation_time` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `todos` (`id` TEXT NOT NULL, `is_favorite` INTEGER NOT NULL, `was_completed` INTEGER NOT NULL, `title` TEXT NOT NULL, `note` TEXT, `deadline_time` INTEGER, `notification_time` INTEGER, `creation_time` INTEGER NOT NULL, `main_image_path` TEXT, `branch_id` TEXT NOT NULL, FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `todos_steps` (`id` TEXT NOT NULL, `was_completed` INTEGER NOT NULL, `title` TEXT NOT NULL, `todo_id` TEXT NOT NULL, FOREIGN KEY (`todo_id`) REFERENCES `todos` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `todos_images` (`image_path` TEXT NOT NULL, `todo_id` TEXT NOT NULL, FOREIGN KEY (`todo_id`) REFERENCES `todos` (`id`) ON UPDATE CASCADE ON DELETE CASCADE, PRIMARY KEY (`image_path`, `todo_id`))');
        await database.execute(
            'CREATE INDEX `index_todos_branch_id` ON `todos` (`branch_id`)');
        await database.execute(
            'CREATE INDEX `index_todos_steps_todo_id` ON `todos_steps` (`todo_id`)');
        await database.execute(
            'CREATE INDEX `index_todos_images_todo_id` ON `todos_images` (`todo_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FloorBranchDao get branchDao {
    return _branchDaoInstance ??= _$FloorBranchDao(database, changeListener);
  }

  @override
  FloorTodoDao get todoDao {
    return _todoDaoInstance ??= _$FloorTodoDao(database, changeListener);
  }

  @override
  FloorTodoStepDao get todoStepDao {
    return _todoStepDaoInstance ??=
        _$FloorTodoStepDao(database, changeListener);
  }

  @override
  FloorTodoImageDao get todoImageDao {
    return _todoImageDaoInstance ??=
        _$FloorTodoImageDao(database, changeListener);
  }
}

class _$FloorBranchDao extends FloorBranchDao {
  _$FloorBranchDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorBranchInsertionAdapter = InsertionAdapter(
            database,
            'branches',
            (FloorBranch item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'branch_theme': _branchThemeConverter.encode(item.theme),
                  'last_usage_time':
                      _dateTimeConverter.encode(item.lastUsageTime),
                  'creation_time': _dateTimeConverter.encode(item.creationTime)
                }),
        _floorBranchUpdateAdapter = UpdateAdapter(
            database,
            'branches',
            ['id'],
            (FloorBranch item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'branch_theme': _branchThemeConverter.encode(item.theme),
                  'last_usage_time':
                      _dateTimeConverter.encode(item.lastUsageTime),
                  'creation_time': _dateTimeConverter.encode(item.creationTime)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorBranch> _floorBranchInsertionAdapter;

  final UpdateAdapter<FloorBranch> _floorBranchUpdateAdapter;

  @override
  Future<List<FloorBranch>> findAllBranches() async {
    return _queryAdapter.queryList('SELECT * FROM branches',
        mapper: (Map<String, dynamic> row) => FloorBranch(
            row['title'] as String,
            _branchThemeConverter.decode(row['branch_theme'] as Uint8List),
            id: row['id'] as String,
            lastUsageTime:
                _dateTimeConverter.decode(row['last_usage_time'] as int),
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int)));
  }

  @override
  Future<FloorBranch> findBranchById(String id) async {
    return _queryAdapter.query('SELECT * FROM branches WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorBranch(
            row['title'] as String,
            _branchThemeConverter.decode(row['branch_theme'] as Uint8List),
            id: row['id'] as String,
            lastUsageTime:
                _dateTimeConverter.decode(row['last_usage_time'] as int),
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int)));
  }

  @override
  Future<void> deleteBranch(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM branches WHERE id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertBranch(FloorBranch branch) async {
    await _floorBranchInsertionAdapter.insert(branch, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBranch(FloorBranch branch) async {
    await _floorBranchUpdateAdapter.update(branch, OnConflictStrategy.abort);
  }
}

class _$FloorTodoDao extends FloorTodoDao {
  _$FloorTodoDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorTodoInsertionAdapter = InsertionAdapter(
            database,
            'todos',
            (FloorTodo item) => <String, dynamic>{
                  'id': item.id,
                  'is_favorite': item.isFavorite ? 1 : 0,
                  'was_completed': item.wasCompleted ? 1 : 0,
                  'title': item.title,
                  'note': item.note,
                  'deadline_time': _dateTimeConverter.encode(item.deadlineTime),
                  'notification_time':
                      _dateTimeConverter.encode(item.notificationTime),
                  'creation_time': _dateTimeConverter.encode(item.creationTime),
                  'main_image_path': item.mainImagePath,
                  'branch_id': item.branchId
                }),
        _floorTodoUpdateAdapter = UpdateAdapter(
            database,
            'todos',
            ['id'],
            (FloorTodo item) => <String, dynamic>{
                  'id': item.id,
                  'is_favorite': item.isFavorite ? 1 : 0,
                  'was_completed': item.wasCompleted ? 1 : 0,
                  'title': item.title,
                  'note': item.note,
                  'deadline_time': _dateTimeConverter.encode(item.deadlineTime),
                  'notification_time':
                      _dateTimeConverter.encode(item.notificationTime),
                  'creation_time': _dateTimeConverter.encode(item.creationTime),
                  'main_image_path': item.mainImagePath,
                  'branch_id': item.branchId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorTodo> _floorTodoInsertionAdapter;

  final UpdateAdapter<FloorTodo> _floorTodoUpdateAdapter;

  @override
  Future<List<FloorTodo>> findAllTodos() async {
    return _queryAdapter.queryList('SELECT * FROM todos',
        mapper: (Map<String, dynamic> row) => FloorTodo(
            row['branch_id'] as String, row['title'] as String,
            id: row['id'] as String,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isFavorite: (row['is_favorite'] as int) != 0,
            wasCompleted: (row['was_completed'] as int) != 0,
            mainImagePath: row['main_image_path'] as String,
            note: row['note'] as String,
            deadlineTime:
                _dateTimeConverter.decode(row['deadline_time'] as int),
            notificationTime:
                _dateTimeConverter.decode(row['notification_time'] as int)));
  }

  @override
  Future<List<FloorTodo>> findTodosOfBranch(String branchId) async {
    return _queryAdapter.queryList('SELECT * FROM todos WHERE branch_id = ?',
        arguments: <dynamic>[branchId],
        mapper: (Map<String, dynamic> row) => FloorTodo(
            row['branch_id'] as String, row['title'] as String,
            id: row['id'] as String,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isFavorite: (row['is_favorite'] as int) != 0,
            wasCompleted: (row['was_completed'] as int) != 0,
            mainImagePath: row['main_image_path'] as String,
            note: row['note'] as String,
            deadlineTime:
                _dateTimeConverter.decode(row['deadline_time'] as int),
            notificationTime:
                _dateTimeConverter.decode(row['notification_time'] as int)));
  }

  @override
  Future<FloorBranch> findBranchOfTodo(String todoId) async {
    return _queryAdapter.query(
        'SELECT b.* FROM branches b JOIN todos t ON t.branch_id = b.id WHERE t.id = ?',
        arguments: <dynamic>[todoId],
        mapper: (Map<String, dynamic> row) => FloorBranch(
            row['title'] as String,
            _branchThemeConverter.decode(row['branch_theme'] as Uint8List),
            id: row['id'] as String,
            lastUsageTime:
                _dateTimeConverter.decode(row['last_usage_time'] as int),
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int)));
  }

  @override
  Future<FloorTodo> findTodoById(String id) async {
    return _queryAdapter.query('SELECT * FROM todos WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorTodo(
            row['branch_id'] as String, row['title'] as String,
            id: row['id'] as String,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isFavorite: (row['is_favorite'] as int) != 0,
            wasCompleted: (row['was_completed'] as int) != 0,
            mainImagePath: row['main_image_path'] as String,
            note: row['note'] as String,
            deadlineTime:
                _dateTimeConverter.decode(row['deadline_time'] as int),
            notificationTime:
                _dateTimeConverter.decode(row['notification_time'] as int)));
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM todos WHERE id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertTodo(FloorTodo todo) async {
    await _floorTodoInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTodo(FloorTodo todo) async {
    await _floorTodoUpdateAdapter.update(todo, OnConflictStrategy.abort);
  }
}

class _$FloorTodoStepDao extends FloorTodoStepDao {
  _$FloorTodoStepDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorTodoStepInsertionAdapter = InsertionAdapter(
            database,
            'todos_steps',
            (FloorTodoStep item) => <String, dynamic>{
                  'id': item.id,
                  'was_completed': item.wasCompleted ? 1 : 0,
                  'title': item.title,
                  'todo_id': item.todoId
                }),
        _floorTodoStepUpdateAdapter = UpdateAdapter(
            database,
            'todos_steps',
            ['id'],
            (FloorTodoStep item) => <String, dynamic>{
                  'id': item.id,
                  'was_completed': item.wasCompleted ? 1 : 0,
                  'title': item.title,
                  'todo_id': item.todoId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorTodoStep> _floorTodoStepInsertionAdapter;

  final UpdateAdapter<FloorTodoStep> _floorTodoStepUpdateAdapter;

  @override
  Future<List<FloorTodoStep>> findStepsOfTodo(String todoId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM todos_steps WHERE todo_id = ?',
        arguments: <dynamic>[todoId],
        mapper: (Map<String, dynamic> row) => FloorTodoStep(
            row['todo_id'] as String, row['title'] as String,
            id: row['id'] as String,
            wasCompleted: (row['was_completed'] as int) != 0));
  }

  @override
  Future<FloorTodoStep> findTodoStepById(String id) async {
    return _queryAdapter.query('SELECT * FROM todos_steps WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => FloorTodoStep(
            row['todo_id'] as String, row['title'] as String,
            id: row['id'] as String,
            wasCompleted: (row['was_completed'] as int) != 0));
  }

  @override
  Future<FloorTodo> findTodoOfStep(String stepId) async {
    return _queryAdapter.query(
        'SELECT t.* FROM todos t JOIN todos_steps ts ON ts.todo_id = t.id WHERE ts.id = ?',
        arguments: <dynamic>[stepId],
        mapper: (Map<String, dynamic> row) => FloorTodo(
            row['branch_id'] as String, row['title'] as String,
            id: row['id'] as String,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isFavorite: (row['is_favorite'] as int) != 0,
            wasCompleted: (row['was_completed'] as int) != 0,
            mainImagePath: row['main_image_path'] as String,
            note: row['note'] as String,
            deadlineTime:
                _dateTimeConverter.decode(row['deadline_time'] as int),
            notificationTime:
                _dateTimeConverter.decode(row['notification_time'] as int)));
  }

  @override
  Future<void> deleteStep(String id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM todos_steps WHERE id = ?',
        arguments: <dynamic>[id]);
  }

  @override
  Future<void> insertStep(FloorTodoStep step) async {
    await _floorTodoStepInsertionAdapter.insert(step, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStep(FloorTodoStep step) async {
    await _floorTodoStepUpdateAdapter.update(step, OnConflictStrategy.abort);
  }
}

class _$FloorTodoImageDao extends FloorTodoImageDao {
  _$FloorTodoImageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _floorTodoImageInsertionAdapter = InsertionAdapter(
            database,
            'todos_images',
            (FloorTodoImage item) => <String, dynamic>{
                  'image_path': item.imagePath,
                  'todo_id': item.todoId
                }),
        _floorTodoImageDeletionAdapter = DeletionAdapter(
            database,
            'todos_images',
            ['image_path', 'todo_id'],
            (FloorTodoImage item) => <String, dynamic>{
                  'image_path': item.imagePath,
                  'todo_id': item.todoId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FloorTodoImage> _floorTodoImageInsertionAdapter;

  final DeletionAdapter<FloorTodoImage> _floorTodoImageDeletionAdapter;

  @override
  Future<List<FloorTodoImage>> findImagesOfTodo(String todoId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM todos_images WHERE todo_id = ?',
        arguments: <dynamic>[todoId],
        mapper: (Map<String, dynamic> row) => FloorTodoImage(
            row['todo_id'] as String, row['image_path'] as String));
  }

  @override
  Future<void> insertImage(FloorTodoImage image) async {
    await _floorTodoImageInsertionAdapter.insert(
        image, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteImage(FloorTodoImage image) async {
    await _floorTodoImageDeletionAdapter.delete(image);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _branchThemeConverter = BranchThemeConverter();
