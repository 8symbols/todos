import 'package:flutter/material.dart';
import 'package:todos/presentation/todos_list/TodosListScreen.dart';

const initialRoute = TodosListScreen.routeName;

final routes = <String, WidgetBuilder>{
  TodosListScreen.routeName: (context) => TodosListScreen(),
};

final RouteFactory onGenerateRoute = null;
