import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/branches/models/branch_statistics.dart';
import 'package:todos/presentation/branches/widgets/branch_card.dart';

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
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => index < branchesStatistics.length
            ? BranchCard(
                branchesStatistics[index],
                onTap: () => onBranchTap(branchesStatistics[index].branch),
                onDelete: () =>
                    onBranchDeleted(branchesStatistics[index].branch),
              )
            : _buildAddButton(context),
        childCount: branchesStatistics.length + 1,
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: RawMaterialButton(
            onPressed: onAddBranch,
            elevation: 8.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            fillColor:
                Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
