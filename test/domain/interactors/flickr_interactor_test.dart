import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/flickr_interactor.dart';
import 'package:todos/domain/models/flickr_page.dart';
import 'package:todos/domain/repositories/i_flickr_repository.dart';

class MockFlickrRepository extends Mock implements IFlickrRepository {}

void main() {
  group('FlickrInteractor', () {
    IFlickrRepository repository;

    setUp(() {
      repository = MockFlickrRepository();
      when(repository.getSearchPhotos(any, any, any))
          .thenAnswer((_) async => FlickrPage([], false));
      when(repository.getRecentPhotos(any, any))
          .thenAnswer((_) async => FlickrPage([], false));
    });

    test('получает недавние изображения', () async {
      final interactor = FlickrInteractor(repository);
      expect(await interactor.getRecentPhotos(1, 1), isA<FlickrPage>());
      verify(repository.getRecentPhotos(any, any));
    });

    test('получает изображения по запросу', () async {
      final interactor = FlickrInteractor(repository);
      expect(await interactor.getSearchPhotos(1, 1, ''), isA<FlickrPage>());
      verify(repository.getSearchPhotos(any, any, any));
    });
  });
}
