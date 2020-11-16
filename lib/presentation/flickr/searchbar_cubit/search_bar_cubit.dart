import 'package:bloc/bloc.dart';

/// Cubit, определяющий, нужно ли показывать строку поиска.
class SearchBarCubit extends Cubit<bool> {
  SearchBarCubit() : super(false);

  void showSearchBar() {
    emit(true);
  }

  void hideSearchBar() {
    emit(false);
  }
}
