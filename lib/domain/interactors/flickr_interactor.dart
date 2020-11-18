import 'package:todos/domain/models/flickr_page.dart';
import 'package:todos/domain/repositories/i_flickr_repository.dart';

/// Интеерактор для работы с изображениями из Flickr.
class FlickrInteractor {
  /// Хранилище изображений.
  final IFlickrRepository _flickrRepository;

  const FlickrInteractor(this._flickrRepository);

  /// Загружает страницу [page] недавних изображений размера [pageSize].
  Future<FlickrPage> getRecentPhotos(int page, int pageSize) async {
    return _flickrRepository.getRecentPhotos(page, pageSize);
  }

  /// Загружает страницу [page] размера [pageSize] по запросу [query].
  Future<FlickrPage> getSearchPhotos(
    int page,
    int pageSize,
    String search,
  ) async {
    return _flickrRepository.getSearchPhotos(page, pageSize, search);
  }
}
