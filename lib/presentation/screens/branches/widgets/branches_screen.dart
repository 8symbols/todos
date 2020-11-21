import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/domain/repositories/i_todos_repository.dart';
import 'package:todos/presentation/screens/branches/branches_bloc/branches_bloc.dart';
import 'package:todos/presentation/screens/branches/widgets/all_todos_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/screens/branches/widgets/branches_grid.dart';
import 'package:todos/presentation/constants/branch_themes.dart';
import 'package:todos/presentation/screens/todos_list/widgets/todo_list_screen.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/branch_editor_dialog.dart';

class BranchesScreen extends StatefulWidget {
  static const routeName = '/branches';

  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  BranchesBloc _branchesBloc;

  @override
  void initState() {
    super.initState();
    final todosRepository = context.read<ITodosRepository>();
    _branchesBloc = BranchesBloc(todosRepository)
      ..add(const BranchesLoadingRequestedEvent());
  }

  @override
  void dispose() {
    _branchesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BranchesBloc>.value(
      value: _branchesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Статистика'),
        ),
        body: BlocBuilder<BranchesBloc, BranchesState>(
          builder: (context, state) => state is BranchesLoadingState
              ? const Center(child: CircularProgressIndicator())
              : _buildStatistics(context, state),
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
    final branch = Branch('', BranchThemes.defaultBranchTheme);

    final createdBranch = await showDialog<Branch>(
      context: context,
      child: BranchEditorDialog(branch, isNewBranch: true),
    );

    if (createdBranch != null) {
      context.read<BranchesBloc>().add(BranchAddedEvent(createdBranch));
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
    await Navigator.of(context)
        .pushNamed(TodoListScreen.routeName, arguments: branch);
    context.read<BranchesBloc>().add(const BranchesLoadingRequestedEvent());
  }
}
