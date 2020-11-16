import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Диалог для выбора изображения.
///
/// Возвращает путь [String] к расположению файла в кеше.
class ImageSelectorDialog extends StatelessWidget {
  final picker = ImagePicker();

  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Выбрать изображение'),
      children: [
        SimpleDialogOption(
          child: const Text('Галерея'),
          onPressed: () async {
            final image = await _getImageFromGallery();
            if (image != null) {
              Navigator.of(context).pop(image);
            }
          },
        ),
        SimpleDialogOption(
          child: const Text('Камера'),
          onPressed: () async {
            final image = await _getImageFromCamera();
            if (image != null) {
              Navigator.of(context).pop(image);
            }
          },
        ),
      ],
    );
  }

  Future<String> _getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  Future<String> _getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return pickedFile?.path;
  }
}
