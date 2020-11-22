import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/todos_repository.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/data/services/settings_storage.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/theme.dart';
import 'package:todos/presentation/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorFloorTodosDatabase.databaseBuilder('todos.db').build();
  runApp(App(database));
}

class App extends StatefulWidget {
  /// База данных задач.
  final FloorTodosDatabase _floorTodosDatabase;

  const App(this._floorTodosDatabase);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ITodosRepository _todosRepository;

  ISettingsStorage _settingsStorage;

  @override
  void initState() {
    super.initState();
    _todosRepository = TodosRepository(widget._floorTodosDatabase);
    _settingsStorage = SettingsStorage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ITodosRepository>.value(value: _todosRepository),
        RepositoryProvider<ISettingsStorage>.value(value: _settingsStorage),
      ],
      child: MaterialApp(
        title: 'Todos',
        theme: theme,
        initialRoute: initialRoute,
        routes: routes,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
