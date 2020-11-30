import 'package:todos/data/dtos/flickr_page_dto.dart';
import 'package:todos/data/dtos/flickr_response_dto.dart';

/// Ответ от Flickr со страницей изображений.
class FlickrPageResponseDto extends FlickrResponseDto {
  /// Изображения.
  final FlickrPageDto photos;

  const FlickrPageResponseDto({
    String stat,
    this.photos,
  }) : super(stat: stat);

  factory FlickrPageResponseDto.fromJson(Map<String, dynamic> json) =>
      FlickrPageResponseDto(
        stat: json['stat'],
        photos: FlickrPageDto.fromJson(json['photos']),
      );

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'photos': photos.toJson(),
    });
}
