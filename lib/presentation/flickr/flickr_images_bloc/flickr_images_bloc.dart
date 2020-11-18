import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todos/domain/interactors/flickr_interactor.dart';
import 'package:todos/domain/repositories/i_flickr_repository.dart';

part 'flickr_images_event.dart';
part 'flickr_images_state.dart';

/// BLoC для управления состоянием списка изображений.
class FlickrImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final FlickrInteractor _flickrInteractor;

  /// Количество изображений на странице.
  final int _pageSize;

  /// Текущий поисковый запрос.
  ///
  /// Равен null в случае, если сейчас просматриваются недавние изображения.
  String _currentQuery;

  FlickrImagesBloc(IFlickrRepository flickrRepository, this._pageSize)
      : _flickrInteractor = FlickrInteractor(flickrRepository),
        super(const ImagesInitialState());

  @override
  Stream<ImagesState> mapEventToState(
    ImagesEvent event,
  ) async* {
    if (event is RecentImagesLoadingRequestedEvent) {
      yield* _mapRecentImagesLoadingRequestedEventToState(event);
    } else if (event is SearchImagesLoadingRequestedEvent) {
      yield* _mapSearchImagesLoadingRequestedEventToState(event);
    } else if (event is NextPageLoadingRequestedEvent) {
      yield* _mapNextPageLoadingRequestedEventToState(event);
    } else if (event is RefreshRequestedEvent) {
      yield* _mapRefreshRequestedEventToState(event);
    }
  }

  Stream<ImagesState> _mapRecentImagesLoadingRequestedEventToState(
    RecentImagesLoadingRequestedEvent event,
  ) async* {
    yield* _updateImages(1);
  }

  Stream<ImagesState> _mapSearchImagesLoadingRequestedEventToState(
    SearchImagesLoadingRequestedEvent event,
  ) async* {
    yield* _updateImages(1, query: event.query);
  }

  Stream<ImagesState> _mapNextPageLoadingRequestedEventToState(
    NextPageLoadingRequestedEvent event,
  ) async* {
    yield* _updateImages(state.page + 1, query: _currentQuery);
  }

  Stream<ImagesState> _mapRefreshRequestedEventToState(
    RefreshRequestedEvent event,
  ) async* {
    yield* _updateImages(1, query: _currentQuery, isRefresh: true);
  }

  /// Загружает картинки со страницы [page] и добавляет их к текущим.
  ///
  /// Если [page] равен 1, удаляет предыдущие.
  ///
  /// Если задан запрос [query], то загрузит фотографии по запросу,
  /// в противном случае загрузит недавние фотографии.
  ///
  /// Если установлен [isRefresh], выбрасывает [ImagesRefreshedState], иначе
  /// выбрасывает [ImagesContentState].
  Stream<ImagesState> _updateImages(
    int page, {
    String query,
    bool isRefresh = false,
  }) async* {
    _currentQuery = query;

    yield page == 1 && !isRefresh
        ? const ImagesLoadingState([], 1, false)
        : ImagesLoadingState(state.urls, state.page, state.wereAllPagesLoaded);

    try {
      final newPage = query == null
          ? await _flickrInteractor.getRecentPhotos(page, _pageSize)
          : await _flickrInteractor.getSearchPhotos(page, _pageSize, query);

      final urls =
          page == 1 ? newPage.urls : (state.urls..addAll(newPage.urls));

      yield isRefresh
          ? ImagesRefreshedState(urls, page, newPage.isLast)
          : ImagesContentState(urls, page, newPage.isLast);
    } catch (_) {
      yield page == 1
          ? const ImagesFailedToLoadState([], 1, false)
          : ImagesFailedToLoadState(
              state.urls,
              state.page,
              state.wereAllPagesLoaded,
            );
    }
  }
}
