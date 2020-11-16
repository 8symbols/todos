import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/presentation/todo/todo_images_bloc/todo_images_bloc.dart';
import 'package:todos/presentation/utils/image_utils.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/image_selector_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Карта с изображениями задачи.
class TodoImagesCard extends StatelessWidget {
  static const _imageSize = 100.0;

  /// Тема ветки.
  final BranchTheme branchTheme;

  const TodoImagesCard(this.branchTheme);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoImagesBloc, TodoImagesState>(
      builder: (context, state) => state is TodoImagesLoadingState
          ? const Center(child: CircularProgressIndicator())
          : Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      ...state.imagesPaths
                          .map((path) => _buildImage(context, path)),
                      _buildAddImageButton(context),
                    ],
                  ),
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
            onDoubleTap: () =>
                ImageUtils.openImageFullScreen(context, FileImage(File(path))),
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
      child: ImageSelectorDialog(branchTheme),
    );

    if (tmpPath != null) {
      context.read<TodoImagesBloc>().add(ImageAddedEvent(tmpPath));
    }
  }

  Future<void> _deleteImage(BuildContext context, String path) async {
    final wasDeletionConfirmed = await showDialog<bool>(
      context: context,
      child: const BooleanDialog(
        title: 'Удалить изображение?',
        content: 'Это действие нельзя отменить.',
        acceptButtonText: 'Подтвердить',
        rejectButtonText: 'Отмена',
      ),
    );

    if (wasDeletionConfirmed == true) {
      context.read<TodoImagesBloc>().add(ImageDeletedEvent(path));
    }
  }
}
