import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/data/dtos/flickr_page_dto.dart';
import 'package:todos/data/dtos/flickr_photo_dto.dart';
import 'package:todos/data/network/flickr_client.dart';
import 'package:todos/data/repositories/flickr_repository.dart';

class MockFlickrClient extends Mock implements FlickrClient {}

void main() {
  group('FlickrRepository', () {
    const flickrPhoto = FlickrPhotoDto(
      title: '',
      id: '',
      farm: 0,
      owner: '',
      secret: '',
      server: '',
      isFriend: false,
      isFamily: false,
      isPublic: false,
    );

    const photosCount = 5;

    final flickrPage = FlickrPageDto(
      perPage: photosCount,
      total: 1,
      pages: 1,
      page: photosCount,
      photos: [for (var i = 0; i < photosCount; ++i) flickrPhoto],
    );

    final flickrClient = MockFlickrClient();
    when(flickrClient.getRecentPhotos(any, any))
        .thenAnswer((_) async => flickrPage);
    when(flickrClient.getSearchPhotos(any, any, any))
        .thenAnswer((_) async => flickrPage);

    final repository = FlickrRepository(flickrClient);

    test('получает недавние изображения', () async {
      final page = await repository.getRecentPhotos(1, 1);
      expect(page.urls.length, photosCount);
    });

    test('получает изображения по запросу', () async {
      final page = await repository.getSearchPhotos(1, 1, '');
      expect(page.urls.length, photosCount);
    });
  });
}
