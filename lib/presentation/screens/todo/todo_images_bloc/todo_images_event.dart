part of 'todo_images_bloc.dart';

@immutable
abstract class TodoImagesEvent {}

/// Запрос загрузки изображений.
class ImagesLoadingRequestedEvent extends TodoImagesEvent {}

/// Добавление картинки.
class ImageAddedEvent extends TodoImagesEvent {
  /// Временный путь к картинке.
  final String tmpPath;

  ImageAddedEvent(this.tmpPath);
}

/// Удаление картинки.
class ImageDeletedEvent extends TodoImagesEvent {
  /// Путь к картинке.
  final String path;

  ImageDeletedEvent(this.path);
}
