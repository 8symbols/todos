import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todos/presentation/blocs/deletion_cubit/deletion_cubit.dart';
import 'package:todos/presentation/screens/todo/blocs/todo_images_bloc/todo_images_bloc.dart';
import 'package:todos/presentation/utils/image_utils.dart';
import 'package:todos/presentation/widgets/boolean_dialog.dart';
import 'package:todos/presentation/widgets/deletable_item.dart';
import 'package:todos/presentation/widgets/deletion_mode_cubit_consumer.dart';
import 'package:todos/presentation/widgets/image_selector_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Карта с изображениями задачи.
class TodoImagesCard extends StatelessWidget {
  static const _imageSize = 100.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoImagesBloc, TodoImagesState>(
      listenWhen: (previous, current) => current is! TodoImagesLoadingState,
      listener: (context, state) {
        final isVibrationMode = context.read<DeletionModeCubit>().state;
        if (isVibrationMode && state.imagesPaths.isEmpty) {
          context.read<DeletionModeCubit>().disableDeletionMode();
        }
      },
      builder: (context, state) => state is TodoImagesLoadingState
          ? const Center(child: CircularProgressIndicator())
          : DeletionModeCubitConsumer(
              builder: (context, isDeletionModeOn) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        ...state.imagesPaths.map((path) => _buildImage(
                              context,
                              path,
                              isDeletionModeOn,
                            )),
                        _buildAddImageButton(context),
                      ],
                    ),
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
          child: const Icon(Icons.attachment, color: Colors.white),
          onPressed: () => addImage(context),
        ),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context,
    String path,
    bool isDeletionPossible,
  ) {
    return DeletableItem(
      isDeletionPossible: isDeletionPossible,
      closeOffset: 4.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
        child: InkWell(
          onLongPress: () =>
              context.read<DeletionModeCubit>().toggleDeletionMode(),
          onDoubleTap: () => ImageUtils.openImageFullScreen(
            context,
            FileImage(File(path)),
            path,
          ),
          child: SizedBox(
            width: _imageSize,
            height: _imageSize,
            child: Hero(
              tag: path,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                isAntiAlias: true,
              ),
            ),
          ),
        ),
      ),
      onDelete: () => _deleteImage(context, path),
    );
  }

  Future<void> addImage(BuildContext context) async {
    context.read<DeletionModeCubit>().disableDeletionMode();

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
