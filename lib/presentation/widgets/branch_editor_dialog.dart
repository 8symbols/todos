import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch.dart';
import 'package:todos/presentation/branch_themes.dart';
import 'package:todos/presentation/widgets/branch_theme_selector.dart';

/// Диалог, который позволяет создать или отредактировать ветку.
///
/// Возвращает отредактированную ветку [Branch] или null.
class BranchEditorDialog extends StatefulWidget {
  /// Максимальное количество символов в названии.
  static const maxTitleLength = 40;

  /// Ветка.
  final Branch branch;

  /// Флаг, сигнализирующий о том, создается сейчас ветка или редактируется.
  ///
  /// Если установлен, то дает возможность выбрать тему.
  final bool isNewBranch;

  BranchEditorDialog(this.branch, {this.isNewBranch = false});

  @override
  _BranchEditorDialogState createState() => _BranchEditorDialogState(branch);
}

class _BranchEditorDialogState extends State<BranchEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  Branch _branch;

  _BranchEditorDialogState(this._branch);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isNewBranch ? 'Создать ветку' : 'Редактировать ветку'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleTextField(context),
              if (widget.isNewBranch) _buildThemeSelector(context),
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
              Navigator.of(context).pop(_branch);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTitleTextField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration.collapsed(
        hintText: 'Введите название ветки',
      ),
      initialValue: _branch.title,
      maxLength: BranchEditorDialog.maxTitleLength,
      maxLengthEnforced: false,
      keyboardType: TextInputType.text,
      onChanged: (value) => _branch = _branch.copyWith(title: value),
      textInputAction: TextInputAction.done,
      maxLines: null,
      validator: (value) {
        if (value.isEmpty) {
          return 'Название не может быть пустым';
        }
        if (value.length > BranchEditorDialog.maxTitleLength) {
          return 'Слишком длинное название';
        }
        return null;
      },
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Выбрать тему',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: BranchThemeSelector(
            BranchThemes.branchThemes,
            _branch.theme,
            onSelect: (selectedTheme) => setState(() {
              _branch = _branch.copyWith(theme: selectedTheme);
            }),
          ),
        ),
      ],
    );
  }
}
