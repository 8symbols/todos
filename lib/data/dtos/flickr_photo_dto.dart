/// Информация о фотографии.
class FlickrPhotoDto {
  /// Идентификатор.
  final String id;

  /// Владелец.
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner': owner,
        'secret': secret,
        'server': server,
        'farm': farm.toString(),
        'title': title,
        'ispublic': isPublic ? '1' : '0',
        'isfriend': isFriend ? '1' : '0',
        'isfamily': isFamily ? '1' : '0',
      };
}
