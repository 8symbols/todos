import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/mock_todos_repository.dart';
import 'package:todos/data/services/settings_storage.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/theme.dart';
import 'routes.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  ITodosRepository _todosRepository;

  ISettingsStorage _settingsStorage;

  @override
  void initState() {
    super.initState();
    _todosRepository = MockTodosRepository();
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
