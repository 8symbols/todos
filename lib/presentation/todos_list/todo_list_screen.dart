import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/todos_list/bloc/todo_list_bloc.dart';
import 'package:todos/presentation/todos_list/todo_list.dart';

/// Экран списка задач.
class TodoListScreen extends StatelessWidget {
  static const routeName = '/todos_list';

  /// Репозиторий для работы с задачами.
  final ITodosRepository _todosRepository;

  /// Ветка задача.
  ///
  /// Может быть равна null.
  final Branch branch;

  /// Флаг, сигнализирующий о том, все ли задачи из списка принадлежат
  /// одной ветке.
  bool get areTodosFromSameBranch => branch != null;

  TodoListScreen(this._todosRepository, {this.branch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoListBloc>(
      create: (context) => TodoListBloc(_todosRepository, branchId: branch.id),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Задачи'),
        ),
        floatingActionButton: BlocBuilder<TodoListBloc, TodoListState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          builder: (context, state) =>
              areTodosFromSameBranch && state is TodosListUsingState
                  ? FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () => _addTodo(context),
                    )
                  : SizedBox.shrink(),
        ),
        body: BlocBuilder<TodoListBloc, TodoListState>(
          builder: (context, state) => state is TodosListLoadingState
              ? const Center(child: CircularProgressIndicator())
              : TodoList(state.todos),
        ),
      ),
    );
  }

  void _addTodo(BuildContext context) {
    context.bloc<TodoListBloc>().add(TodoAddedEvent(Todo('todo')));
  }
}
