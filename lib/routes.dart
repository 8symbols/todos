import 'package:flutter/material.dart';
import 'todos_list/ui/TodosListScreen.dart';

const initialRoute = TodosListScreen.routeName;

final routes = <String, WidgetBuilder>{
  TodosListScreen.routeName: (context) => TodosListScreen(),
};

final RouteFactory onGenerateRoute = null;
