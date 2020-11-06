import 'package:flutter/material.dart';

typedef void OnOptionSelectedCallback(BuildContext context);

/// Данные для элемента выпадающего списка.
class PopupMenuItemData {
  /// Иконка.
  final IconData icon;

  /// Текст.
  final String title;

  /// Callback, который будет вызван при нажатии на элемент.
  final OnOptionSelectedCallback onSelected;

  const PopupMenuItemData(this.icon, this.title, {@required this.onSelected});
}
