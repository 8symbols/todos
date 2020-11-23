import 'package:flutter/material.dart';
import 'package:todos/presentation/screens/branches/models/todos_statistics.dart';
import 'package:todos/presentation/screens/branches/widgets/mountains_animation.dart';
import 'package:todos/presentation/widgets/linear_progress_painter.dart';

/// Карта со статистикой по всем задачам.
class AllTodosCard extends StatelessWidget {
  /// Статистика по задачам.
  final TodosStatistics todosStatistics;

  /// Callback при нажатии на карту.
  final VoidCallback onTap;

  const AllTodosCard(this.todosStatistics, {@required this.onTap});

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(16.0));

    return Card(
      color: const Color(0xFF86A5F5),
      elevation: 8.0,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _buildStatistics(context)),
                MountainsAnimation(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Все задачи',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          'Завершено ${todosStatistics.completedTodosCount} задач'
          ' из ${todosStatistics.todosCount}',
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 32.0),
          child: _buildProgress(context),
        ),
      ],
    );
  }

  Widget _buildProgress(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: todosStatistics.completionProgress),
      builder: (context, value, child) => CustomPaint(
        size: const Size.fromHeight(16.0),
        painter: LinearProgressPainter(
          value,
          Theme.of(context).floatingActionButtonTheme.backgroundColor,
        ),
      ),
    );
  }
}
