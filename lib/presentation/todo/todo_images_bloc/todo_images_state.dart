part of 'todo_images_bloc.dart';

@immutable
abstract class TodoImagesState {
  /// Пути к картинкам.
  ///
  /// Может быть равным null.
  final List<String> imagesPaths;

  TodoImagesState(this.imagesPaths);
}

/// Состояние загрузки картинок.
class TodoImagesLoadingState extends TodoImagesState {
  TodoImagesLoadingState() : super(null);
}

/// Состояние использования картинок.
class TodoImagesContentState extends TodoImagesState {
  TodoImagesContentState(List<String> imagesPaths) : super(imagesPaths);
}

/// Состояние после возникновения ошибки при добавлении картинки.
class FailedToAddImageState extends TodoImagesState {
  FailedToAddImageState(List<String> imagesPaths) : super(imagesPaths);
}
