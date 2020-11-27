import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:todos/presentation/constants/assets_paths.dart';
import 'package:todos/presentation/screens/flickr/blocs/flickr_images_bloc/flickr_images_bloc.dart';
import 'package:todos/presentation/utils/image_utils.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Таблица картинок из Flickr.
class FlickrImagesGrid extends StatefulWidget {
  @override
  _FlickrImagesGridState createState() => _FlickrImagesGridState();
}

class _FlickrImagesGridState extends State<FlickrImagesGrid> {
  static const _imageSpacing = 16.0;

  Completer<void> _loadingCompleter;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _loadingCompleter = Completer<void>();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlickrImagesBloc, ImagesState>(
      listenWhen: (previous, current) => previous is ImagesLoadingState,
      listener: (context, state) {
        if (state is! ImagesContentState) {
          _loadingCompleter.complete();
          _loadingCompleter = Completer<void>();
        }
        if (state.page == 1) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
      builder: (context, state) => RefreshIndicator(
        onRefresh: () {
          context.read<FlickrImagesBloc>().add(const RefreshRequestedEvent());
          return _loadingCompleter.future;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            const loadingDelta = 500.0;
            if (notification.metrics.pixels >
                notification.metrics.maxScrollExtent - loadingDelta) {
              _loadNextPage(context);
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (state.urls.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    top: _imageSpacing,
                    left: _imageSpacing,
                    right: _imageSpacing,
                  ),
                  sliver: _buildGrid(context, state),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(_imageSpacing),
                sliver: SliverToBoxAdapter(
                  child: _buildStatus(context, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, ImagesState state) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: _imageSpacing,
        mainAxisSpacing: _imageSpacing,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => CachedNetworkImage(
          imageUrl: state.urls[index],
          errorWidget: (context, url, error) => const Image(
            image: AssetImage(AssetsPaths.imageNotAvailable),
            fit: BoxFit.cover,
          ),
          placeholder: (context, url) => const Image(
            image: AssetImage(AssetsPaths.imagePlaceholder),
            fit: BoxFit.cover,
          ),
          imageBuilder: (context, imageProvider) => InkWell(
            onTap: () => _selectImage(context, state.urls[index]),
            onDoubleTap: () => ImageUtils.openImageFullScreen(
              context,
              imageProvider,
              state.urls[index],
            ),
            child: Hero(
              tag: state.urls[index],
              child: Image(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        childCount: state.urls.length,
      ),
    );
  }

  Widget _buildStatus(BuildContext context, ImagesState state) {
    return Center(
      child: state is ImagesFailedToLoadState
          ? const Text('Произошла ошибка.')
          : state.wereAllPagesLoaded
              ? const Text('Больше изображений нет.')
              : VisibilityDetector(
                  key: UniqueKey(),
                  onVisibilityChanged: (info) {
                    if (!info.visibleBounds.isEmpty) {
                      _loadNextPage(context);
                    }
                  },
                  child: const CircularProgressIndicator(),
                ),
    );
  }

  void _loadNextPage(BuildContext context) {
    if (context.read<FlickrImagesBloc>().state is! ImagesLoadingState) {
      context
          .read<FlickrImagesBloc>()
          .add(const NextPageLoadingRequestedEvent());
    }
  }

  Future<void> _selectImage(BuildContext context, String url) async {
    final wasSelectionConfirmed = await showDialog<bool>(
      context: context,
      child: const BooleanDialog(
        title: 'Подтвердите выбор',
        content: 'Добавить изображение к задаче?',
      ),
    );

    if (wasSelectionConfirmed == true) {
      final file = await DefaultCacheManager().getSingleFile(url);
      Navigator.of(context).pop(file.path);
    }
  }
}
