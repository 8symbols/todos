import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/todos_list/branch_cubit/branch_cubit.dart';
import 'package:todos/presentation/todos_list/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/todos_list/widgets/todo_list.dart';
import 'package:todos/presentation/todos_list/widgets/todo_list_screen_menu_options.dart';
import 'package:todos/presentation/widgets/todo_editor_dialog.dart';

/// Экран списка задач.
class TodoListScreen extends StatefulWidget {
  static const routeName = '/todos_list';

  /// Ветка задача.
  ///
  /// Может быть равна null.
  final Branch branch;

  TodoListScreen({this.branch});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  /// Флаг, сигнализирующий о том, все ли задачи из списка принадлежат
  /// одной ветке.
  bool get areTodosFromSameBranch => widget.branch != null;

  TodoListBloc _todoListBloc;

  BranchCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    final todosRepository = context.read<ITodosRepository>();
    final settingsStorage = context.read<ISettingsStorage>();

    _todoListBloc = TodoListBloc(
      todosRepository,
      settingsStorage,
      branchId: widget.branch?.id,
    )..add(InitializationRequestedEvent());

    _themeCubit = BranchCubit(todosRepository, branch: widget.branch);
  }

  @override
  void dispose() {
    _todoListBloc.close();
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoListBloc>.value(value: _todoListBloc),
        BlocProvider<BranchCubit>.value(value: _themeCubit),
      ],
      child: BlocBuilder<BranchCubit, Branch>(
        builder: (context, state) => Theme(
          data: Theme.of(context).copyWith(
            primaryColor: state?.theme?.primaryColor ??
                BranchThemes.defaultBranchTheme.primaryColor,
            scaffoldBackgroundColor: state?.theme?.secondaryColor ??
                BranchThemes.defaultBranchTheme.secondaryColor,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Marquee(
                directionMarguee: DirectionMarguee.oneDirection,
                animationDuration: const Duration(seconds: 4),
                child: Text(
                  areTodosFromSameBranch ? state.title : 'Все задачи',
                ),
              ),
              actions: [TodoListScreenMenuOptions(areTodosFromSameBranch)],
            ),
            floatingActionButton: areTodosFromSameBranch ? _buildFab() : null,
            body: BlocConsumer<TodoListBloc, TodoListState>(
              listener: (context, state) {
                if (state is TodoListDeletedTodoState) {
                  _showUndoSnackBar(context, state.branchId, state.todo);
                }
              },
              builder: (context, state) => state is TodoListLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : TodoList(state.todos),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return BlocBuilder<TodoListBloc, TodoListState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) => state is TodoListContentState
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _addTodo(context),
            )
          : SizedBox.shrink(),
    );
  }

  /// Создает диалог с созданием новой задачи.
  void _addTodo(BuildContext context) async {
    final newTodo = Todo('');
    final branchTheme = context.read<BranchCubit>().state?.theme ??
        BranchThemes.defaultBranchTheme;
    final editedTodo = await showDialog<Todo>(
      context: context,
      builder: (context) =>
          TodoEditorDialog(newTodo, branchTheme, isNewTodo: true),
    );

    if (editedTodo != null) {
      context.read<TodoListBloc>().add(TodoAddedEvent(editedTodo));
    }
  }

  void _showUndoSnackBar(BuildContext context, String branchId, Todo todo) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Задача "${todo.title}" удалена.'),
          action: SnackBarAction(
            label: "Отменить",
            onPressed: () => context
                .read<TodoListBloc>()
                .add(TodoRestoredEvent(branchId, todo)),
          ),
        ),
      );
  }
}
