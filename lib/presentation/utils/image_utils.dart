import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Функции для работы с изображениями.
abstract class ImageUtils {
  /// Открывает изображение на весь экран.
  static void openImageFullScreen(
    BuildContext context,
    ImageProvider imageProvider,
    String heroTag,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Container(
          child: PhotoView(
            imageProvider: imageProvider,
            heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
          ),
        ),
      ),
    );
  }
}
