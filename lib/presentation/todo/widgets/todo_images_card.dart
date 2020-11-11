import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todos/presentation/todo/todo_images_bloc/todo_images_bloc.dart';
import 'package:todos/presentation/widgets/image_selector_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

/// Карта с изображениями задачи.
class TodoImagesCard extends StatelessWidget {
  static const _imageSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoImagesBloc, TodoImagesState>(
      builder: (context, state) => state is TodoImagesLoadingState
          ? const Center(child: CircularProgressIndicator())
          : Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 12.0),
                    ...state.imagesPaths
                        .map((path) => _buildImage(context, path)),
                    _buildAddImageButton(context),
                    const SizedBox(width: 12.0),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAddImageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: _imageSize,
        width: 60.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child: const Icon(Icons.attachment, color: Colors.white),
          onPressed: () => addImage(context),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, String path) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
          child: InkWell(
            onTap: () => openImageFullscreen(context, path),
            child: SizedBox(
              width: _imageSize,
              height: _imageSize,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          right: 4.0,
          top: 4.0,
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: RaisedButton(
              padding: const EdgeInsets.all(2.0),
              shape: CircleBorder(),
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              child: const FittedBox(
                child: Icon(Icons.close, color: Colors.white),
              ),
              onPressed: () => _deleteImage(context, path),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addImage(BuildContext context) async {
    final tmpPath = await showDialog(
      context: context,
      child: ImageSelectorDialog(),
    );

    if (tmpPath != null) {
      context.read<TodoImagesBloc>().add(ImageAddedEvent(tmpPath));
    }
  }

  Future<void> _deleteImage(BuildContext context, String path) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      child: AlertDialog(
        title: const Text('Удалить изображение?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          FlatButton(
            child: const Text('Подтвердить'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          FlatButton(
            child: const Text('Отмена'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );

    if (wasDeletionConfirmed == true) {
      context.read<TodoImagesBloc>().add(ImageDeletedEvent(path));
    }
  }

  void openImageFullscreen(BuildContext context, String path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Container(
          child: PhotoView(
            imageProvider: FileImage(File(path)),
          ),
        ),
      ),
    );
  }
}
