import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/todos_repository.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/data/services/settings_storage.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/blocs_resolvers/todos_blocs_resolver.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/routes.dart';
import 'package:todos/presentation/utils/branch_theme_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

  ThemeCubit _themeCubit;

  TodosBlocsResolver _todoBlocsResolver;

  @override
  void initState() {
    super.initState();
    _todosRepository = TodosRepository(widget._floorTodosDatabase);
    _settingsStorage = SettingsStorage();
    _themeCubit = ThemeCubit(
      BranchThemeUtils.createThemeData(BranchThemes.defaultBranchTheme),
    );
    _todoBlocsResolver = TodosBlocsResolver();
  }

  @override
  void dispose() {
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ITodosRepository>.value(value: _todosRepository),
        RepositoryProvider<ISettingsStorage>.value(value: _settingsStorage),
        RepositoryProvider<TodosBlocsResolver>.value(value: _todoBlocsResolver),
      ],
      child: BlocProvider<ThemeCubit>.value(
        value: _themeCubit,
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, theme) => MaterialApp(
            title: 'Todos',
            theme: theme,
            initialRoute: initialRoute,
            routes: routes,
            onGenerateRoute: onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
