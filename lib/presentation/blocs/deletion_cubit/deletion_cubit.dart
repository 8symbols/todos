import 'package:bloc/bloc.dart';
import 'package:todos/presentation/widgets/deletable_item.dart';

/// Cubit, контролирующий, активирован ли режим удаления.
///
/// Предполагается, что он используется в сочетании с [DeletableItem].
class DeletionModeCubit extends Cubit<bool> {
  DeletionModeCubit() : super(false);

  /// Активирует режим удаления.
  void enableDeletionMode() => emit(true);

  /// Деактивирует режим удаления.
  void disableDeletionMode() => emit(false);

  /// Переключает режим удаления.
  void toggleDeletionMode() => emit(!state);
}
