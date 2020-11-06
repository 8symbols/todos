import 'package:flutter/material.dart';
import 'package:todos/presentation/theme.dart';
import 'routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      theme: theme,
      initialRoute: initialRoute,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
