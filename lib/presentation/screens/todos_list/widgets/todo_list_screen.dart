import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/screens/todos_list/blocs/branch_cubit/branch_cubit.dart';
import 'package:todos/presentation/screens/todos_list/blocs/todo_list_bloc/todo_list_bloc.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list_screen_menu_options.dart';
import 'package:todos/presentation/utils/branch_theme_utils.dart';
import 'package:todos/presentation/widgets/marquee.dart';
import 'package:todos/presentation/widgets/todo_editor_dialog.dart';

/// Экран списка задач.
class TodoListScreen extends StatefulWidget {
  static const routeName = '/todos_list';

  /// Ветка задач.
  ///
  /// Может быть равна null. В этом случае экран содержит все задачи.
  final Branch branch;

  TodoListScreen({this.branch});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TodoListBloc _todoListBloc;

  BranchCubit _branchCubit;

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

    _branchCubit = BranchCubit(todosRepository, branch: widget.branch);
    if (widget.branch != null) {
      _branchCubit
          .editBranch(widget.branch.copyWith(lastUsageTime: DateTime.now()));
    }
  }

  @override
  void dispose() {
    _todoListBloc.close();
    _branchCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoListBloc>.value(value: _todoListBloc),
        BlocProvider<BranchCubit>.value(value: _branchCubit),
      ],
      child: BlocConsumer<BranchCubit, Branch>(
        listenWhen: (previous, current) => previous?.theme != current?.theme,
        listener: (context, state) => context
            .read<ThemeCubit>()
            .setTheme(BranchThemeUtils.createTheme(state.theme)),
        builder: (context, branch) => BlocBuilder<TodoListBloc, TodoListState>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: Marquee(child: Text(branch?.title ?? 'Все задачи')),
              actions: [
                TodoListScreenMenuOptions(branch, state),
              ],
            ),
            floatingActionButton: _buildFab(context, state, branch),
            body: BlocListener<TodoListBloc, TodoListState>(
              listener: (context, state) {
                if (state is TodoListDeletedTodoState) {
                  _showUndoSnackBar(context, state.branchId, state.todo);
                }
              },
              child: state is TodoListLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : TodoList(state.todos),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context, TodoListState state, Branch branch) {
    return state is TodoListLoadingState || branch == null
        ? null
        : FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _addTodo(context),
          );
  }

  /// Создает диалог с созданием новой задачи.
  void _addTodo(BuildContext context) async {
    final newTodo = Todo('');
    final editedTodo = await showDialog<Todo>(
      context: context,
      builder: (context) => TodoEditorDialog(newTodo, isNewTodo: true),
    );

    if (editedTodo != null) {
      context.read<TodoListBloc>().add(TodoAddedEvent(editedTodo));
    }
  }

  void _showUndoSnackBar(BuildContext context, String branchId, Todo todo) {
    Navigator.popUntil(context, ModalRoute.withName(TodoListScreen.routeName));

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
