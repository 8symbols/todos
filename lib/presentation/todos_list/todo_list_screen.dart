import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/todos_list/bloc/todos_list_bloc.dart';
import 'package:todos/presentation/todos_list/todo_list.dart';

class TodoListScreen extends StatelessWidget {
  static const routeName = '/todos_list';

  final ITodosRepository _todosRepository;
  final String branchId;

  bool get areTodosFromSameBranch => branchId == null;

  TodoListScreen(this._todosRepository, {this.branchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosListBloc>(
      create: (context) => TodosListBloc(_todosRepository, branchId: branchId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Задачи'),
        ),
        floatingActionButton: BlocBuilder<TodosListBloc, TodosListState>(
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
        body: BlocBuilder<TodosListBloc, TodosListState>(
          builder: (context, state) => state is TodosListLoadingState
              ? const Center(child: CircularProgressIndicator())
              : TodoList(state.todos),
        ),
      ),
    );
  }

  void _addTodo(BuildContext context) {
    context.bloc<TodosListBloc>().add(TodoAddedEvent(Todo('todo')));
  }
}
