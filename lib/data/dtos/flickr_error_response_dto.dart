import 'package:todos/data/dtos/flickr_response_dto.dart';

/// Ответ от Flickr с информацией об ошибке.
class FlickrErrorResponseDto extends FlickrResponseDto {
  /// Код ошибки.
  final int code;

  /// Сообщение.
  final String message;

  const FlickrErrorResponseDto({
    String stat,
    this.code,
    this.message,
  }) : super(stat: stat);

  factory FlickrErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      FlickrErrorResponseDto(
        stat: json['stat'],
        code: int.parse(json['code']),
        message: json['message'],
      );

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'code': code.toString(),
      'message': message,
    });
}
