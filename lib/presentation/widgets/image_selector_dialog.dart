import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/presentation/flickr/widgets/flickr_screen.dart';

/// Диалог для выбора изображения.
///
/// Возвращает путь [String] к расположению файла в кеше.
class ImageSelectorDialog extends StatelessWidget {
  /// Тема ветки.
  final BranchTheme _branchTheme;

  final _imagePicker = ImagePicker();

  ImageSelectorDialog(this._branchTheme);

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
        SimpleDialogOption(
          child: const Text('Flickr'),
          onPressed: () async {
            final image = await _getImageFromFlickr(context);
            if (image != null) {
              Navigator.of(context).pop(image);
            }
          },
        ),
      ],
    );
  }

  Future<String> _getImageFromGallery() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  Future<String> _getImageFromCamera() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.camera);
    return pickedFile?.path;
  }

  Future<String> _getImageFromFlickr(BuildContext context) async {
    final path = await Navigator.of(context)
        .pushNamed(FlickrScreen.routeName, arguments: _branchTheme);
    return path;
  }
}
