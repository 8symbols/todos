import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/presentation/screens/branches/widgets/branches_screen.dart';
import 'package:todos/presentation/screens/flickr/widgets/flickr_screen.dart';
import 'package:todos/presentation/screens/todo/models/todo_screen_arguments.dart';
import 'package:todos/presentation/screens/todo/widgets/todo_screen.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list_screen.dart';

const initialRoute = BranchesScreen.routeName;

final routes = <String, WidgetBuilder>{
  BranchesScreen.routeName: (context) => BranchesScreen(),
};

final RouteFactory onGenerateRoute = (settings) {
  switch (settings.name) {
    case TodoListScreen.routeName:
      final Branch branch = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => TodoListScreen(branch: branch),
      );
    case TodoScreen.routeName:
      final TodoScreenArguments arguments = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => TodoScreen(arguments.branchTheme, arguments.todo),
      );
    case FlickrScreen.routeName:
      final BranchTheme branchTheme = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => FlickrScreen(branchTheme),
      );
    default:
      return null;
  }
};
