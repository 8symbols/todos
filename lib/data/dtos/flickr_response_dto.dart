/// Базовый ответ от Flickr.
class FlickrResponseDto {
  /// Результат обработки запроса.
  final String stat;

  const FlickrResponseDto({this.stat});

  factory FlickrResponseDto.fromJson(Map<String, dynamic> json) =>
      FlickrResponseDto(stat: json['stat']);
}
