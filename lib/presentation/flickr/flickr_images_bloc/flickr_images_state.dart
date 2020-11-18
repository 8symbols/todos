part of 'flickr_images_bloc.dart';

@immutable
abstract class ImagesState {
  /// Адреса картинок.
  final List<String> urls;

  /// Номер последней страницы.
  ///
  /// Должен быть положительным числом.
  final int page;

  /// Были ли загружены с сервера все страницы изображений.
  final bool wereAllPagesLoaded;

  const ImagesState(this.urls, this.page, this.wereAllPagesLoaded)
      : assert(urls != null),
        assert(wereAllPagesLoaded != null),
        assert(page > 0);
}

/// Изначальное состояние.
class ImagesInitialState extends ImagesState {
  const ImagesInitialState() : super(const [], 1, false);
}

/// Состояние просмотра изображений.
class ImagesContentState extends ImagesState {
  const ImagesContentState(
    List<String> urls,
    int page,
    bool wereAllPagesLoaded,
  ) : super(urls, page, wereAllPagesLoaded);
}

/// Состояние после перезагрузки.
class ImagesRefreshedState extends ImagesState {
  const ImagesRefreshedState(
    List<String> urls,
    int page,
    bool wereAllPagesLoaded,
  ) : super(urls, page, wereAllPagesLoaded);
}

/// Состояние загрузки изображений.
class ImagesLoadingState extends ImagesState {
  const ImagesLoadingState(
    List<String> urls,
    int page,
    bool wereAllPagesLoaded,
  ) : super(urls, page, wereAllPagesLoaded);
}

/// Состояние ошибки загрузки.
class ImagesFailedToLoadState extends ImagesState {
  const ImagesFailedToLoadState(
    List<String> urls,
    int page,
    bool wereAllPagesLoaded,
  ) : super(urls, page, wereAllPagesLoaded);
}
