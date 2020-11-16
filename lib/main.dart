import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/mock_todos_repository.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/theme.dart';
import 'routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ITodosRepository>(
      create: (context) => MockTodosRepository(),
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
