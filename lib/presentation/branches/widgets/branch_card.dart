import 'package:flutter/material.dart';
import 'package:todos/presentation/branches/models/branch_statistics.dart';
import 'package:todos/presentation/widgets/deletable_item.dart';
import 'package:todos/presentation/widgets/radial_progress_painter.dart';

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
  });

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
                  _buildProgress(context),
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

  Widget _buildProgress(BuildContext context) {
    final percent = (branchStatistics.completionProgress * 100.0).round();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      tween: Tween(begin: 0.0, end: branchStatistics.completionProgress),
      builder: (context, value, child) => SizedBox(
        width: 48.0,
        height: 48.0,
        child: CustomPaint(
          child: child,
          painter: RadialProgressPainter(
            value,
            branchStatistics.branch.theme.primaryColor,
          ),
        ),
      ),
      child: Center(
        child: Text(
          '$percent%',
          style: TextStyle(
            color: branchStatistics.branch.theme.primaryColor,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
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
          branchStatistics.branch.theme.secondaryColor,
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
      padding: const EdgeInsets.only(top: 2.0, right: 2.0),
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
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
