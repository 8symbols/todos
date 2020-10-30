import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/todos_list/bloc/todos_list_bloc.dart';

class TodosListScreen extends StatelessWidget {
  static const routeName = '/todos_list';

  final ITodosRepository _todosRepository;
  final String branchId;

  bool get areTodosFromSameBranch => branchId == null;

  TodosListScreen(this._todosRepository, {this.branchId});

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
              : _TodosList(state.todos),
        ),
      ),
    );
  }

  void _addTodo(BuildContext context) {
    context.bloc<TodosListBloc>().add(TodoAddedEvent(Todo('todo')));
  }
}

class _TodosList extends StatelessWidget {
  final List<Todo> todos;

  _TodosList(this.todos);

  @override
  Widget build(BuildContext context) {
    const kEmptySpaceForFabHeight = 88.0;

    return todos.isEmpty
        ? const Center(child: Text('Нет элементов'))
        : ListView(
            children: [
              ...todos.map((e) => _Todo(e)).toList(),
              const SizedBox(height: kEmptySpaceForFabHeight),
            ],
          );
  }
}

class _Todo extends StatelessWidget {
  final Todo todo;

  _Todo(this.todo);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(todo.id),
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
                    .add(TodoEditedEvent(todo.id, editedTodo));
              },
            ),
            Expanded(child: Text(todo.title)),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                context.bloc<TodosListBloc>().add(TodoDeletedEvent(todo.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
