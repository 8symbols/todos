import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/todos_repository.dart';
import 'package:todos/data/services/floor_todos_database.dart';
import 'package:todos/data/services/settings_storage.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/routes.dart';
import 'package:todos/presentation/utils/branch_theme_utils.dart';

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

  ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _todosRepository = TodosRepository(widget._floorTodosDatabase);
    _settingsStorage = SettingsStorage();

    final theme = BranchThemeUtils.createTheme(BranchThemes.defaultBranchTheme);
    _themeCubit = ThemeCubit(theme);
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ITodosRepository>.value(value: _todosRepository),
        RepositoryProvider<ISettingsStorage>.value(value: _settingsStorage),
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
