import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:todos/domain/models/todo.dart';
import 'package:todos/domain/wrappers/nullable.dart';
import 'package:todos/presentation/branch_themes.dart';
import 'package:todos/presentation/widgets/image_selector_dialog.dart';
import 'package:todos/presentation/widgets/select_datetime_button.dart';

/// Диалог, который позволяет создать или отредактировать задачу.
class TodoEditorDialog extends StatefulWidget {
  /// Максимальное количество символов в названии.
  static const maxTitleLength = 40;

  /// Задача.
  final Todo todo;

  /// Тема ветки.
  final BranchTheme branchTheme;

  /// Флаг, сигнализирующий о том, создается сейчас задача или редактируется.
  ///
  /// Если установлен, то дает возможность отредактировать название,
  /// время уведомления и время дедлайна. Если не установлен, то дает
  /// возможность отредактировать название и фотографию темы.
  final bool isNewTodo;

  TodoEditorDialog(this.todo, this.branchTheme, {this.isNewTodo = false});

  @override
  _TodoEditorDialogState createState() => _TodoEditorDialogState(todo);
}

class _TodoEditorDialogState extends State<TodoEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  Todo _todo;

  _TodoEditorDialogState(this._todo);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNewTodo ? 'Создать задачу' : 'Редактировать задачу'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleTextField(context),
              if (widget.isNewTodo) _buildTimeButtons(context),
              if (!widget.isNewTodo) _buildSelectPhotoButton(context),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Отмена'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Ок'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.of(context).pop(_todo);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTitleTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration.collapsed(
        hintText: 'Введите название задачи',
      ),
      initialValue: _todo.title,
      maxLength: TodoEditorDialog.maxTitleLength,
      maxLengthEnforced: false,
      keyboardType: TextInputType.text,
      onChanged: (value) => _todo = _todo.copyWith(title: value),
      textInputAction: TextInputAction.done,
      maxLines: null,
      validator: (value) {
        if (value.isEmpty) {
          return 'Название не может быть пустым';
        }
        if (value.length > TodoEditorDialog.maxTitleLength) {
          return 'Слишком длинное название';
        }
        return null;
      },
    );
  }

  Widget _buildTimeButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        SelectDateTimeButton(
          const Icon(Icons.notifications_active_outlined),
          'Напомнить',
          color: BranchThemes.defaultBranchTheme.secondaryColor,
          dateTime: _todo.notificationTime,
          onSelected: (dateTime) => setState(() {
            _todo = _todo.copyWith(notificationTime: Nullable(dateTime));
          }),
        ),
        const SizedBox(height: 4.0),
        SelectDateTimeButton(
          const Icon(Icons.event),
          'Добавить дату выполнения',
          color: BranchThemes.defaultBranchTheme.secondaryColor,
          dateTime: _todo.deadlineTime,
          onSelected: (dateTime) => setState(() {
            _todo = _todo.copyWith(deadlineTime: Nullable(dateTime));
          }),
        ),
      ],
    );
  }

  Widget _buildSelectPhotoButton(BuildContext context) {
    return _todo.themeImagePath == null
        ? TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Добавить главное фото'),
            onPressed: () async {
              final imagePath = await showDialog<String>(
                context: context,
                child: ImageSelectorDialog(widget.branchTheme),
              );
              if (imagePath != null) {
                setState(() {
                  _todo = _todo.copyWith(themeImagePath: Nullable(imagePath));
                });
              }
            },
          )
        : TextButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('Удалить главное фото'),
            onPressed: () => setState(() {
              _todo = _todo.copyWith(themeImagePath: Nullable(null));
            }),
          );
  }
}
