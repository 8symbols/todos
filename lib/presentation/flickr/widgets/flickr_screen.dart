import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/data/repositories/flickr_repository.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/presentation/flickr/flickr_images_bloc/flickr_images_bloc.dart';
import 'package:todos/presentation/flickr/searchbar_cubit/search_bar_cubit.dart';
import 'package:todos/presentation/flickr/widgets/flickr_images_grid.dart';
import 'package:todos/presentation/flickr/widgets/search_appbar.dart';

/// Экран для выбора изображения из Flickr.
///
/// Возвращает строку с путем к картинке в кеше или null.
class FlickrScreen extends StatefulWidget {
  static const routeName = '/flickr';

  /// Тема ветки.
  final BranchTheme _branchTheme;

  FlickrScreen(this._branchTheme);

  @override
  _FlickrScreenState createState() => _FlickrScreenState();
}

class _FlickrScreenState extends State<FlickrScreen> {
  SearchBarCubit _searchBarCubit;

  FlickrImagesBloc _imagesBloc;

  int get _pageSize =>
      4 *
      FlickrImagesGrid.columnsCounts.values
          .fold(1, (previousValue, element) => previousValue * element);

  @override
  void initState() {
    super.initState();
    _searchBarCubit = SearchBarCubit();
    _imagesBloc = FlickrImagesBloc(FlickrRepository(), _pageSize)
      ..add(RecentImagesLoadingRequestedEvent());
  }

  @override
  void dispose() {
    _searchBarCubit.close();
    _imagesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBarCubit>.value(value: _searchBarCubit),
        BlocProvider<FlickrImagesBloc>.value(value: _imagesBloc),
      ],
      child: Scaffold(
        backgroundColor: widget._branchTheme.secondaryColor,
        appBar: _buildAppBar(context),
        body: FlickrImagesGrid(),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56.0),
      child: BlocBuilder<SearchBarCubit, bool>(
        builder: (context, shouldShowSearchBar) => shouldShowSearchBar
            ? SearchAppBar(
                backgroundColor: widget._branchTheme.primaryColor,
                hintText: 'Найти изображения...',
                onSubmitted: (query) => context.read<FlickrImagesBloc>().add(
                      SearchImagesLoadingRequestedEvent(query),
                    ),
                onBackPressed: () {
                  context.read<FlickrImagesBloc>().add(
                        const RecentImagesLoadingRequestedEvent(),
                      );
                  context.read<SearchBarCubit>().hideSearchBar();
                },
              )
            : AppBar(
                backgroundColor: widget._branchTheme.primaryColor,
                title: const Text('Недавнее'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        context.read<SearchBarCubit>().showSearchBar(),
                  )
                ],
              ),
      ),
    );
  }
}
