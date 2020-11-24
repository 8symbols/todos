import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';

/// [WillPopScope], который при попытке закрытия деактивирует
/// [DeletionModeCubit], если он активен.
class DeletionModeWillPopScope extends StatelessWidget {
  /// Дочерний виджет.
  final Widget child;

  const DeletionModeWillPopScope({@required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isDeletionMode = context.read<DeletionModeCubit>().state;
        if (isDeletionMode) {
          context.read<DeletionModeCubit>().disableDeletionMode();
        }
        return !isDeletionMode;
      },
      child: child,
    );
  }
}
