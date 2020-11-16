import 'package:todos/data/dtos/flickr_page_dto.dart';
import 'package:todos/domain/models/flickr_page.dart';

/// Mapper для [FlickrPage].
abstract class FlickrPageMapper {
  /// Создает [FlickrPage] на основе [FlickrPageDto].
  static FlickrPage fromFlickrPageDto(FlickrPageDto photosDto) {
    final urls = photosDto.photos.map((e) => e.url).toList();
    final isLast = photosDto.page >= photosDto.pages;
    return FlickrPage(urls, isLast);
  }
}
