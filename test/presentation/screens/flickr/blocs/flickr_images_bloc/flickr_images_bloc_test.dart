import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todos/domain/interactors/flickr_interactor.dart';
import 'package:todos/domain/models/flickr_page.dart';
import 'package:todos/presentation/screens/flickr/blocs/flickr_images_bloc/flickr_images_bloc.dart';

class MockFlickrInteractor extends Mock implements FlickrInteractor {}

void main() {
  group('FlickrImagesBloc', () {
    FlickrInteractor interactor;

    setUp(() async {
      interactor = MockFlickrInteractor();
    });

    blocTest<FlickrImagesBloc, ImagesState>(
      'не изменяет состояние, если не приходят события',
      build: () => FlickrImagesBloc(interactor, 20),
      expect: [],
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'загружает недавние изображения',
      build: () {
        when(interactor.getRecentPhotos(any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(interactor, 20);
      },
      act: (bloc) => bloc..add(RecentImagesLoadingRequestedEvent()),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesContentState>(),
      ],
      verify: (_) => verify(interactor.getRecentPhotos(any, any)),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'загружает изображения по запросу',
      build: () {
        when(interactor.getSearchPhotos(any, any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(interactor, 20);
      },
      act: (bloc) => bloc..add(SearchImagesLoadingRequestedEvent('')),
      expect: [
        isA<ImagesLoadingState>(),
        isA<ImagesContentState>(),
      ],
      verify: (_) => verify(interactor.getSearchPhotos(any, any, any)),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'обновляет недавние изображения',
      build: () {
        when(interactor.getRecentPhotos(any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(interactor, 20);
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
      verify: (_) => verify(interactor.getRecentPhotos(any, any)).called(2),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'обновляет изображения по запросу',
      build: () {
        when(interactor.getSearchPhotos(any, any, any))
            .thenAnswer((_) async => FlickrPage([], false));
        return FlickrImagesBloc(interactor, 20);
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
          verify(interactor.getSearchPhotos(any, any, any)).called(2),
    );

    blocTest<FlickrImagesBloc, ImagesState>(
      'устанавливает состояние ошибки при ошибке загрузки',
      build: () {
        when(interactor.getRecentPhotos(any, any)).thenThrow(Exception());
        when(interactor.getSearchPhotos(any, any, any)).thenThrow(Exception());
        return FlickrImagesBloc(interactor, 20);
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
