import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/todos_repository/models/todo.dart';
import 'package:todos/data/repositories/todos_repository/repositories/i_todos_repository.dart';
import 'package:todos/presentation/todos_list/bloc/todos_list_bloc.dart';

class TodosListScreen extends StatelessWidget {
  static const routeName = '/todos_list';

  final ITodosRepository _todosRepository;
  final String branchId;

  TodosListScreen(this._todosRepository, {this.branchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodosListBloc>(
      create: (context) => TodosListBloc(_todosRepository, branchId: branchId),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Задачи'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TodosListBloc, TodosListState>(
                builder: (context, state) => state is TodosListLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _TodosList()),
          ),
        ),
      ),
    );
  }
}

class _TodosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosListBloc, TodosListState>(
      builder: (context, state) {
        final todos = (state as TodosListUsing).todos;
        return todos.isEmpty
            ? const Center(child: Text('Нет элементов'))
            : SingleChildScrollView(
                child: Column(children: todos.map((e) => _Todo(e)).toList()),
              );
      },
    );
  }
}

class _Todo extends StatelessWidget {
  final Todo todo;

  _Todo(this.todo);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: todo.wasCompleted,
              onChanged: (newValue) {
                final editedTodo = todo.copyWith(wasCompleted: newValue);
                context
                    .bloc<TodosListBloc>()
                    .add(TodoEdited(todo.id, editedTodo));
              },
            ),
            Expanded(child: Text(todo.title)),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                context.bloc<TodosListBloc>().add(TodoDeleted(todo.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
