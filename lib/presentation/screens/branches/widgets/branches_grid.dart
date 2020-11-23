import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';
import 'package:todos/presentation/screens/branches/models/branch_statistics.dart';
import 'package:todos/presentation/screens/branches/widgets/branch_card.dart';
import 'package:todos/presentation/widgets/deletion_mode_cubit_consumer.dart';

typedef void OnBranchActionCallback(Branch branch);

/// Сетка из карт веток.
class BranchesGrid extends StatelessWidget {
  /// Статистика по веткам.
  final List<BranchStatistics> branchesStatistics;

  /// Callback при нажатии на ветку.
  final OnBranchActionCallback onBranchTap;

  /// Callback при удалении ветки.
  final OnBranchActionCallback onBranchDeleted;

  /// Callback при добавлении новой ветки.
  final VoidCallback onAddBranch;

  const BranchesGrid(
    this.branchesStatistics, {
    @required this.onBranchTap,
    @required this.onBranchDeleted,
    @required this.onAddBranch,
  });

  @override
  Widget build(BuildContext context) {
    return DeletionModeCubitConsumer(
      builder: (context, isDeletionModeOn) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => index < branchesStatistics.length
              ? BranchCard(
                  branchesStatistics[index],
                  isDeletionModeOn,
                  onTap: () => onBranchTap(branchesStatistics[index].branch),
                  onDelete: () =>
                      onBranchDeleted(branchesStatistics[index].branch),
                  key: ValueKey(branchesStatistics[index].branch.id),
                  onLongPress: () =>
                      context.read<DeletionModeCubit>().toggleDeletionMode(),
                )
              : _buildAddButton(context, index.isEven),
          childCount: branchesStatistics.length + 1,
          findChildIndexCallback: (key) {
            final id = (key as ValueKey).value;
            final index = branchesStatistics.indexWhere(
              (branchStatistics) => branchStatistics.branch.id == id,
            );
            return index == -1 ? null : index;
          },
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, bool isVertical) {
    final button = Padding(
      padding: const EdgeInsets.all(4.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 80.0, height: 80.0),
        child: RaisedButton(
          onPressed: onAddBranch,
          elevation: 8.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );

    return isVertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [button],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [button],
          );
  }
}
