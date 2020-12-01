import 'package:bloc/bloc.dart';
import 'package:todos/domain/interactors/settings_interactor.dart';
import 'package:todos/presentation/screens/flickr/blocs/searchbar_cubit/searchbar_state.dart';

/// Cubit, определяющий, нужно ли показывать строку поиска.
class SearchBarCubit extends Cubit<SearchBarState> {
  /// Интерактор для работы с настройками.
  final SettingsInteractor _settingsInteractor;

  SearchBarCubit(this._settingsInteractor)
      : super(const SearchBarState(false, null));

  Future<void> saveLastQuery(String query) async {
    await _settingsInteractor.saveLastFlickrQuery(query);
  }

  Future<void> showSearchBar() async {
    final lastQuery = await _settingsInteractor.getLastFlickrQuery();
    emit(SearchBarState(true, lastQuery));
  }

  void hideSearchBar() {
    emit(SearchBarState(false, state.lastQuery));
  }
}
