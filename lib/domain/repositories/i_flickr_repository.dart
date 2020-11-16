import 'package:todos/domain/models/flickr_page.dart';

/// Интерфейс хранилища изображений из Flickr.
abstract class IFlickrRepository {
  /// Загружает страницу [page] недавних изображений размера [pageSize].
  Future<FlickrPage> getRecentPhotos(int page, int pageSize);

  /// Загружает страницу [page] размера [pageSize] по запросу [query].
  Future<FlickrPage> getSearchPhotos(int page, int pageSize, String query);
}
