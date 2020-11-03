import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/branch_themes.dart';
import 'package:todos/presentation/todos_list/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/todos_list/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/todos_list/widgets/todo_list.dart';
import 'package:todos/presentation/todos_list/widgets/todo_list_screen_menu_options.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoListBloc>(
          create: (context) =>
              TodoListBloc(_todosRepository, branchId: branch?.id),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(_todosRepository, branch: branch),
        )
      ],
      child: BlocBuilder<ThemeCubit, BranchTheme>(
        builder: (context, state) => Scaffold(
          backgroundColor:
              state?.secondaryColor ?? defaultBranchTheme.secondaryColor,
          appBar: AppBar(
            backgroundColor:
                state?.primaryColor ?? defaultBranchTheme.primaryColor,
            title: const Text('Задачи'),
            actions: [TodoListScreenMenuOptions(areTodosFromSameBranch)],
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
      ),
    );
  }

  void _addTodo(BuildContext context) {
    context.bloc<TodoListBloc>().add(TodoAddedEvent(Todo('todo')));
  }
}
