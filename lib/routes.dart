import 'package:flutter/material.dart';
import 'package:todos/data/repositories/mock_todos_repository.dart';
import 'package:todos/presentation/todos_list/widgets/todo_list_screen.dart';

const initialRoute = TodoListScreen.routeName;

final routes = <String, WidgetBuilder>{
  TodoListScreen.routeName: (context) {
    // Временная заглушка. В дальнейшем репозиторий будет передаваться сверху.
    final repository = MockTodosRepository();
    return TodoListScreen(repository, branch: repository.getAnyBranch());
  }
};

final RouteFactory onGenerateRoute = null;
