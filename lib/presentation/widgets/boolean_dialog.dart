import 'package:flutter/material.dart';
import 'package:todos/presentation/constants/keys.dart';

/// Диалог, в котором пользователь может согласиться или отказаться.
///
/// Возвращает [bool] или null.
class BooleanDialog extends StatelessWidget {
  /// Заголовок диалога.
  final String title;

  /// Содержание диалога.
  final String content;

  /// Текст на кнопке отказа.
  ///
  /// По умолчанию равняется "Нет".
  final String rejectButtonText;

  /// Текст на кнопке согласия.
  ///
  /// По умолчанию равняется "Да".
  final String acceptButtonText;

  const BooleanDialog({
    @required this.title,
    @required this.content,
    this.rejectButtonText = 'Нет',
    this.acceptButtonText = 'Да',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          key: const ValueKey(Keys.rejectButton),
          child: Text(rejectButtonText),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          key: const ValueKey(Keys.acceptButton),
          child: Text(acceptButtonText),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
}
