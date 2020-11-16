/// Возможные результаты обработки запроса на Flickr.
abstract class FlickrResponseStatus {
  /// Запрос успешно обработан.
  static const ok = 'ok';

  /// Произошла ошибка.
  static const fail = 'fail';
}
