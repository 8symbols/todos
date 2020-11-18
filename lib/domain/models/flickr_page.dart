/// Страница изображений из Flickr.
class FlickrPage {
  /// Адреса изображений.
  final List<String> urls;

  /// Является ли эта страница последней.
  final bool isLast;

  const FlickrPage(this.urls, this.isLast);
}