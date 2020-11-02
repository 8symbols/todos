import 'package:flutter/material.dart';
import 'package:todos/data/repositories/mock_todos_repository.dart';
import 'package:todos/presentation/todos_list/todo_list_screen.dart';

const initialRoute = TodoListScreen.routeName;

final routes = <String, WidgetBuilder>{
  TodoListScreen.routeName: (context) => TodoListScreen(MockTodosRepository()),
};

final RouteFactory onGenerateRoute = null;
