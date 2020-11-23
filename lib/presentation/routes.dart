import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/presentation/screens/branches/widgets/branches_screen.dart';
import 'package:todos/presentation/screens/flickr/widgets/flickr_screen.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_screen.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list_screen.dart';

const initialRoute = BranchesScreen.routeName;

final routes = <String, WidgetBuilder>{
  BranchesScreen.routeName: (context) => BranchesScreen(),
  FlickrScreen.routeName: (context) => FlickrScreen(),
};

final RouteFactory onGenerateRoute = (settings) {
  switch (settings.name) {
    case TodoListScreen.routeName:
      final Branch branch = settings.arguments;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => TodoListScreen(branch: branch),
      );
    case TodoScreen.routeName:
      final Todo todo = settings.arguments;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => TodoScreen(todo),
      );
    default:
      return null;
  }
};
