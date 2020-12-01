import 'package:flutter/material.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/domain/interactors/todos_interactor.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/domain/services/i_settings_storage.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';
import 'package:todos/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:todos/presentation/blocs_resolvers/todos_blocs_resolver.dart';
import 'package:todos/presentation/screens/branches/blocs/branches_bloc/branches_bloc.dart';
import 'package:todos/presentation/screens/branches/widgets/all_todos_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/screens/branches/widgets/branches_grid.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/branches/widgets/branches_screen_menu_options.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list_screen.dart';
import 'package:todos/presentation/utils/branch_theme_utils.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/branch_editor_dialog.dart';
import 'package:todos/presentation/widgets/deletion_mode_will_pop_scope.dart';

class BranchesScreen extends StatefulWidget {
  static const routeName = '/branches';

  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  BranchesBloc _branchesBloc;

  DeletionModeCubit _deletionModeCubit;

  TodosBlocsResolver _todosBlocsResolver;

  @override
  void initState() {
    super.initState();
    final todosRepository = context.read<ITodosRepository>();
    final settingsStorage = context.read<ISettingsStorage>();

    _branchesBloc = BranchesBloc(
      TodosInteractor(todosRepository),
      SettingsInteractor(settingsStorage),
    )..add(const InitializationRequestedEvent());
    _deletionModeCubit = DeletionModeCubit();

    _todosBlocsResolver = context.read<TodosBlocsResolver>();
    _todosBlocsResolver.registerObserver(
      _branchesBloc,
      onUpdate: (bloc) => bloc.add(const BranchesOutdatedEvent()),
    );
  }

  @override
  void dispose() {
    _todosBlocsResolver.unregister(_branchesBloc);

    _branchesBloc.close();
    _deletionModeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BranchesBloc>.value(value: _branchesBloc),
        BlocProvider<DeletionModeCubit>.value(value: _deletionModeCubit),
      ],
      child: BlocConsumer<BranchesBloc, BranchesState>(
        listenWhen: (previous, current) => current is! BranchesLoadingState,
        listener: (context, state) {
          final isVibrationMode = context.read<DeletionModeCubit>().state;
          if (isVibrationMode && state.branchesStatistics.isEmpty) {
            context.read<DeletionModeCubit>().disableDeletionMode();
          }
        },
        builder: (context, state) => DeletionModeWillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Статистика'),
              actions: [
                if (state is! BranchesLoadingState)
                  const BranchesScreenMenuOptions()
              ],
            ),
            body: state is BranchesLoadingState
                ? const Center(child: CircularProgressIndicator())
                : _buildStatistics(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, BranchesState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
            child: AllTodosCard(
              state.todosStatistics,
              onTap: () => _openTodosScreen(context),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: const Text(
              'Ветки задач',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
          sliver: BranchesGrid(
            state.branchesStatistics,
            onBranchTap: (branch) => _openTodosScreen(context, branch),
            onBranchDeleted: (branch) => _deleteBranch(context, branch),
            onAddBranch: () => _addBranch(context),
          ),
        ),
      ],
    );
  }

  Future<void> _addBranch(BuildContext context) async {
    context.read<DeletionModeCubit>().disableDeletionMode();

    final newBranch = await showDialog<Branch>(
      context: context,
      barrierDismissible: false,
      child: BranchEditorDialog(
        Branch('', BranchThemes.defaultBranchTheme),
        isNewBranch: true,
      ),
    );

    if (newBranch != null) {
      context.read<BranchesBloc>().add(BranchAddedEvent(newBranch));
    }
  }

  Future<void> _deleteBranch(BuildContext context, Branch branch) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      child: const BooleanDialog(
        title: 'Подтвердите удаление',
        content: 'Удалить ветку? Это действие необратимо.',
        rejectButtonText: 'Отменить',
        acceptButtonText: 'Подтвердить',
      ),
    );

    if (wasDeletionConfirmed == true) {
      context.read<BranchesBloc>().add(BranchDeletedEvent(branch));
    }
  }

  Future<void> _openTodosScreen(BuildContext context, [Branch branch]) async {
    context.read<DeletionModeCubit>().disableDeletionMode();

    final currentTheme = context.read<ThemeCubit>().state;
    if (branch != null) {
      context
          .read<ThemeCubit>()
          .setTheme(BranchThemeUtils.createThemeData(branch.theme));
    }

    _todosBlocsResolver.pauseObserver(_branchesBloc);
    await Navigator.of(context)
        .pushNamed(TodoListScreen.routeName, arguments: branch);
    _todosBlocsResolver.continueObserver(_branchesBloc);

    if (branch != null) {
      context.read<ThemeCubit>().setTheme(currentTheme);
    }
  }
}
