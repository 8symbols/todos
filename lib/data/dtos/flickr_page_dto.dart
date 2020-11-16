import 'package:todos/data/dtos/flickr_photo_dto.dart';

/// Информация о странице изображений.
class FlickrPageDto {
  /// Номер страницы.
  final int page;

  /// Страниц всего.
  final int pages;

  /// Изображений на странице.
  final int perPage;

  /// Общее количество изображений.
  final int total;

  /// Изображения.
  final List<FlickrPhotoDto> photos;

  const FlickrPageDto({
    this.page,
    this.pages,
    this.perPage,
    this.total,
    this.photos,
  });

  factory FlickrPageDto.fromJson(Map<String, dynamic> json) => FlickrPageDto(
        page: int.parse(json['page']),
        pages: int.parse(json['pages']),
        perPage: int.parse(json['perpage']),
        total: int.parse(json['total']),
        photos: json['photo']
            .map<FlickrPhotoDto>((e) => FlickrPhotoDto.fromJson(e))
            .toList(),
      );
}
