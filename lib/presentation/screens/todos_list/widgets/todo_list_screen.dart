import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/blocs_resolvers/todos_blocs_resolver.dart';
import 'package:todos/presentation/models/todo_data.dart';
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

  TodosBlocsResolver _todosBlocsResolver;

  @override
  void initState() {
    super.initState();
    final todosRepository = context.read<ITodosRepository>();
    final settingsStorage = context.read<ISettingsStorage>();

    _todoListBloc = TodoListBloc(
      TodosInteractor(todosRepository),
      SettingsInteractor(settingsStorage),
      branchId: widget.branch?.id,
    )..add(InitializationRequestedEvent());

    _branchCubit = BranchCubit(
      TodosInteractor(todosRepository),
      branch: widget.branch,
    );
    if (widget.branch != null) {
      _branchCubit
          .editBranch(widget.branch.copyWith(lastUsageTime: DateTime.now()));
    }

    _todosBlocsResolver = context.read<TodosBlocsResolver>();

    _todosBlocsResolver
      ..register(
        _todoListBloc,
        const [TodoListUpdatedState, TodoListLoadingState],
        onUpdate: (bloc) => bloc.add(const TodoListOutdatedEvent()),
      )
      ..registerObservable(_branchCubit, const []);
  }

  @override
  void dispose() {
    _todosBlocsResolver
      ..unregisterObserver(_todoListBloc)
      ..unregisterObserver(_branchCubit);

    _todoListBloc
        .close()
        .then((_) => _todosBlocsResolver.unregisterObservable(_todoListBloc));
    _branchCubit
        .close()
        .then((_) => _todosBlocsResolver.unregisterObservable(_branchCubit));
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
        listener: (context, branch) => context
            .read<ThemeCubit>()
            .setTheme(BranchThemeUtils.createThemeData(branch.theme)),
        builder: (context, branch) {
          return BlocBuilder<TodoListBloc, TodoListState>(
            builder: (context, todoListState) => Scaffold(
              appBar: AppBar(
                title: Marquee(
                  child: Text(branch?.title ?? 'Все задачи'),
                ),
                actions: [
                  TodoListScreenMenuOptions(branch, todoListState),
                ],
              ),
              floatingActionButton: _buildFab(context, todoListState, branch),
              body: BlocListener<TodoListBloc, TodoListState>(
                listener: (context, state) {
                  if (state is TodoListTodoDeletedState) {
                    _showUndoSnackBar(context, state.todoData);
                  }
                },
                child: todoListState is TodoListLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : TodoList(todoListState.todosStatistics),
              ),
            ),
          );
        },
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
    final newTodo = await showDialog<Todo>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TodoEditorDialog(Todo(''), isNewTodo: true),
    );

    if (newTodo != null) {
      context.read<TodoListBloc>().add(TodoAddedEvent(newTodo));
    }
  }

  void _showUndoSnackBar(BuildContext context, TodoData deletedTodoData) {
    if (ModalRoute.of(context).isCurrent) {
      _hideBottomSheet(context);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Задача "${deletedTodoData.todo.title}" удалена.'),
          action: SnackBarAction(
            label: "Отменить",
            onPressed: () => context
                .read<TodoListBloc>()
                .add(TodoRestoredEvent(deletedTodoData)),
          ),
        ),
      );
  }

  void _hideBottomSheet(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(TodoListScreen.routeName));
  }
}
