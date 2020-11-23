import 'package:flutter/material.dart';
import 'package:todos/presentation/screens/branches/models/branch_statistics.dart';
import 'package:todos/presentation/widgets/deletable_item.dart';
import 'package:todos/presentation/widgets/tween_radial_progress.dart';

/// Карта со статистикой по ветке задач.
class BranchCard extends StatelessWidget {
  /// Статистика ветки.
  final BranchStatistics branchStatistics;

  /// Callback при нажатии на карту.
  final VoidCallback onTap;

  /// Callback при удалении.
  final VoidCallback onDelete;

  const BranchCard(
    this.branchStatistics, {
    @required this.onTap,
    @required this.onDelete,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DeletableItem(
      closePosition: 0.0,
      onDelete: onDelete,
      child: SizedBox.expand(
        child: InkWell(
          onTap: onTap,
          child: Card(
            elevation: 8.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenRadialProgress(
                    branchStatistics.completionProgress,
                    branchStatistics.branch.theme.primaryColor,
                  ),
                  Spacer(),
                  Text(
                    branchStatistics.branch.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${branchStatistics.todosCount} задач(и)',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF979797),
                      fontSize: 13.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: _buildCounts(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounts(BuildContext context) {
    return Wrap(
      children: [
        _buildCountContainer(
          context,
          '${branchStatistics.completedTodosCount} сделано',
          branchStatistics.branch.theme.primaryColor,
          branchStatistics.branch.theme.secondaryColor.withOpacity(0.5),
        ),
        _buildCountContainer(
          context,
          '${branchStatistics.uncompletedTodosCount} осталось',
          const Color(0xFFFD3535),
          const Color.fromARGB(51, 253, 53, 53),
        ),
      ],
    );
  }

  Widget _buildCountContainer(
    BuildContext context,
    String text,
    Color textColor,
    Color backgroundColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, right: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
