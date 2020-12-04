import 'package:todos/data/network/flickr_client.dart';
import 'package:todos/domain/models/flickr_page.dart';
import 'package:todos/domain/repositories/i_flickr_repository.dart';
import 'package:todos/data/mappers/flickr_page_mapper.dart';

/// Хранилище изображений из Flickr.
///
/// Методы могут бросать исключения.
class FlickrRepository extends IFlickrRepository {
  /// Клиент для работы с API Flickr.
  final FlickrClient client;

  FlickrRepository(this.client);

  @override
  Future<FlickrPage> getRecentPhotos(int page, int pageSize) async {
    final photos = await client.getRecentPhotos(page, pageSize);
    return FlickrPageMapper.fromFlickrPageDto(photos);
  }

  @override
  Future<FlickrPage> getSearchPhotos(
    int page,
    int pageSize,
    String query,
  ) async {
    final photos = await client.getSearchPhotos(page, pageSize, query);
    return FlickrPageMapper.fromFlickrPageDto(photos);
  }
}
