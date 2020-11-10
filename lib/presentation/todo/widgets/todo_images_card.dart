import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todos/presentation/todo/todo_images_bloc/todo_images_bloc.dart';
import 'package:todos/presentation/widgets/image_selector_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return SizedBox(
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
    );
  }

  Future<void> addImage(BuildContext context) async {
    final tmpPath = await showDialog(
      context: context,
      child: ImageSelectorDialog(),
    );

    if (tmpPath != null) {
      context.bloc<TodoImagesBloc>().add(ImageAddedEvent(tmpPath));
    }
  }

  Widget _buildImage(BuildContext context, String path) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
          child: SizedBox(
            width: _imageSize,
            height: _imageSize,
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 4.0,
          top: 4.0,
          child: InkWell(
            onTap: () =>
                context.bloc<TodoImagesBloc>().add(ImageDeletedEvent(path)),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              width: 20.0,
              height: 20.0,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
