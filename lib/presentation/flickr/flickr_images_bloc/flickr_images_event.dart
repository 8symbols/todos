part of 'flickr_images_bloc.dart';

@immutable
abstract class ImagesEvent {
  const ImagesEvent();
}

/// События запроса загрузки первой страницы недавних изображений.
class RecentImagesLoadingRequestedEvent extends ImagesEvent {
  const RecentImagesLoadingRequestedEvent();
}

/// События запроса загрузки первой страницы изображений по запросу.
class SearchImagesLoadingRequestedEvent extends ImagesEvent {
  /// Поисковый запрос.
  final String query;

  const SearchImagesLoadingRequestedEvent(this.query);
}

/// Событие загрузки следующей страницы изображений.
class NextPageLoadingRequestedEvent extends ImagesEvent {
  const NextPageLoadingRequestedEvent();
}

/// Событие запроса повторной загрузки первой страницы.
class RefreshRequestedEvent extends ImagesEvent {
  const RefreshRequestedEvent();
}
