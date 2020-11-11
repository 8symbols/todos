import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/presentation/widgets/datetime_selector_dialog.dart';

typedef void OnDateTimeSelected(DateTime selectedTime);

/// Кнопка для выбора времени.
class SelectDateTimeButton extends StatelessWidget {
  static final _dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  /// Иконка.
  final Icon icon;

  /// Заголовок.
  ///
  /// Отображается, если [dateTime] равен null.
  final String title;

  /// Дата и время.
  ///
  /// Может быть равным null.
  final DateTime dateTime;

  /// Callback при выборе времени.
  final OnDateTimeSelected onSelected;

  /// Цвет кнопки.
  ///
  /// Может быть равным null.
  final Color color;

  SelectDateTimeButton(
    this.icon,
    this.title, {
    @required this.onSelected,
    this.dateTime,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      icon: icon,
      color: color,
      label: Expanded(
        child: Text(dateTime == null ? title : _dateFormat.format(dateTime)),
      ),
      onPressed: () async {
        final dateTime = await showDialog<DateTime>(
          context: context,
          child: DateTimeSelectorDialog(),
        );
        if (dateTime != null) {
          onSelected(dateTime);
        }
      },
    );
  }
}
