import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';
import 'package:todos/presentation/utils/vibration_utils.dart';

/// Потребитель [DeletionModeCubit].
class DeletionModeCubitConsumer extends StatelessWidget {
  /// Функция, которая создает потомка.
  final BlocWidgetBuilder<bool> builder;

  const DeletionModeCubitConsumer({@required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeletionModeCubit, bool>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) => VibrationUtils.vibrate(50),
      buildWhen: (previous, current) => previous != current,
      builder: builder,
    );
  }
}
