import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/models/flickr_page.dart';
import 'package:todos/domain/repositories/i_flickr_repository.dart';
import 'package:todos/presentation/screens/flickr/blocs/flickr_images_bloc/flickr_images_bloc.dart';

class MockFlickrRepository extends Mock implements IFlickrRepository {}

void main() {
  group('FlickrImagesBloc', () {
    IFlickrRepository repository;

    setUp(() async {
      repository = MockFlickrRepository();
    });

    blocTest<FlickrImagesBloc, ImagesState>(
      'не изменяет состояние, если не приходят события',
      build: () => FlickrImagesBloc(repository, 20),
      expect: [],
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'загружает недавние изображения',
      build: () {
        when(repository.getRecentPhotos(any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(repository, 20);
      },
      act: (bloc) => bloc..add(RecentImagesLoadingRequestedEvent()),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesContentState>(),
      ],
      verify: (_) => verify(repository.getRecentPhotos(any, any)),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'загружает изображения по запросу',
      build: () {
        when(repository.getSearchPhotos(any, any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(repository, 20);
      },
      act: (bloc) => bloc..add(SearchImagesLoadingRequestedEvent('')),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesContentState>(),
      ],
      verify: (_) => verify(repository.getSearchPhotos(any, any, any)),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'обновляет недавние изображения',
      build: () {
        when(repository.getRecentPhotos(any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(repository, 20);
      },
      act: (bloc) => bloc
        ..add(RecentImagesLoadingRequestedEvent())
        ..add(RefreshRequestedEvent()),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesContentState>(),
        isA<ImagesLoadingState>(),
        isA<ImagesRefreshedState>(),
      ],
      verify: (_) => verify(repository.getRecentPhotos(any, any)).called(2),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'обновляет изображения по запросу',
      build: () {
        when(repository.getSearchPhotos(any, any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(repository, 20);
      },
      act: (bloc) => bloc
        ..add(SearchImagesLoadingRequestedEvent(''))
        ..add(RefreshRequestedEvent()),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesContentState>(),
        isA<ImagesLoadingState>(),
        isA<ImagesRefreshedState>(),
      ],
      verify: (_) =>
          verify(repository.getSearchPhotos(any, any, any)).called(2),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'устанавливает состояние ошибки при ошибке загрузки',
      build: () {
        when(repository.getRecentPhotos(any, any)).thenThrow(Exception());
        when(repository.getSearchPhotos(any, any, any)).thenThrow(Exception());
        return FlickrImagesBloc(repository, 20);
      },
      act: (bloc) => bloc
        ..add(RecentImagesLoadingRequestedEvent())
        ..add(SearchImagesLoadingRequestedEvent('')),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesFailedToLoadState>(),
        isA<ImagesLoadingState>(),
        isA<ImagesFailedToLoadState>(),
      ],
    );
  });
}
