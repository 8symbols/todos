import 'package:flutter/material.dart';
import 'package:todos/data/repositories/todos_repository/repositories/mock_todos_repository.dart';
import 'package:todos/presentation/todos_list/TodosListScreen.dart';

const initialRoute = TodosListScreen.routeName;

final routes = <String, WidgetBuilder>{
  TodosListScreen.routeName: (context) =>
      TodosListScreen(MockTodosRepository()),
};

final RouteFactory onGenerateRoute = null;
