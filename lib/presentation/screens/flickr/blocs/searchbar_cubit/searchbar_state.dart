/// Состояние строки поиска.
class SearchBarState {
  /// Следует ли ее показывать.
  final bool shouldShow;

  /// Последний поисковый запрос.
  ///
  /// Может равняться null.
  final String lastQuery;

  const SearchBarState(this.shouldShow, this.lastQuery);
}
