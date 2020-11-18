/// Информация о фотографии.
class FlickrPhotoDto {
  /// Идентификатор.
  final String id;

  /// Владалец.
  final String owner;

  final String secret;

  /// Сервер изображения.
  final String server;

  final int farm;

  /// Описание.
  final String title;

  final bool isPublic;

  final bool isFriend;

  final bool isFamily;

  /// Адрес.
  String get url => 'https://live.staticflickr.com/$server/${id}_$secret.jpg';

  const FlickrPhotoDto({
    this.id,
    this.owner,
    this.secret,
    this.server,
    this.farm,
    this.title,
    this.isPublic,
    this.isFriend,
    this.isFamily,
  });

  factory FlickrPhotoDto.fromJson(Map<String, dynamic> json) => FlickrPhotoDto(
        id: json['id'],
        owner: json['owner'],
        secret: json['secret'],
        server: json['server'],
        farm: int.parse(json['farm']),
        title: json['title'],
        isPublic: int.parse(json['ispublic']) != 0,
        isFriend: int.parse(json['isfriend']) != 0,
        isFamily: int.parse(json['isfamily']) != 0,
      );
}
