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
          builder: (context, state) => state is TodosListUsingState
              ? _TodosListFab()
              : SizedBox.shrink(),
        ),
        body: BlocBuilder<TodosListBloc, TodosListState>(
          buildWhen: (previous, current) =>
              previous.runtimeType != current.runtimeType,
          builder: (context, state) => state is TodosListLoadingState
              ? const Center(child: CircularProgressIndicator())
              : _TodosList(),
        ),
      ),
    );
  }
}

class _TodosListFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosListBloc, TodosListState>(
      buildWhen: (previous, current) =>
          (previous as TodosListUsingState).shouldShowFAB !=
          (current as TodosListUsingState).shouldShowFAB,
      builder: (context, state) {
        const kFabSize = 56.0;
        final shouldShow = (state as TodosListUsingState).shouldShowFAB;
        final endSize = shouldShow ? kFabSize : 0.0;

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: kFabSize, end: endSize),
          duration: const Duration(milliseconds: 250),
          builder: (BuildContext context, double size, Widget child) {
            return Container(
              width: size,
              height: size,
              child: FittedBox(
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    context
                        .bloc<TodosListBloc>()
                        .add(TodoAddedEvent(Todo(title: 'todo')));
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TodosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosListBloc, TodosListState>(
      buildWhen: (previous, current) =>
          (previous as TodosListUsingState).todos !=
          (current as TodosListUsingState).todos,
      builder: (context, state) {
        final todos = (state as TodosListUsingState).todos;
        return todos.isEmpty
            ? const Center(child: Text('Нет элементов'))
            : _TodosListNotEmpty(todos.map((e) => _Todo(e)).toList());
      },
    );
  }
}

class _TodosListNotEmpty extends StatefulWidget {
  final List<_Todo> todos;

  _TodosListNotEmpty(this.todos);

  @override
  __TodosListNotEmptyState createState() => __TodosListNotEmptyState();
}

class __TodosListNotEmptyState extends State<_TodosListNotEmpty> {
  ScrollController _controller;

  void _scrollListener() {
    // TODO: Доработать логику необходимости отображения.
    final direction = _controller.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      context.bloc<TodosListBloc>().add(ShouldShowFabChangedEvent(false));
    } else if (direction == ScrollDirection.forward) {
      context.bloc<TodosListBloc>().add(ShouldShowFabChangedEvent(true));
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        children: widget.todos,
      ),
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
