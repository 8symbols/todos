import 'package:flutter/material.dart';
import 'routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos',
      initialRoute: initialRoute,
      routes: routes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
