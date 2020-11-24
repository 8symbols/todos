import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/presentation/widgets/datetime_selector_dialog.dart';

typedef OnDateTimeSelected = void Function(DateTime selectedDateTime);

/// Виджет для установки даты и времени.
class SelectTimeItem extends StatelessWidget {
  static final _dateFormat = DateFormat('dd.MM.yyyy HH:mm');

  /// Иконка.
  final Icon icon;

  /// Надпись.
  ///
  /// Отображается, когда [dateTime] равен null.
  final String title;

  /// Дата и время.
  ///
  /// Может быть равным null.
  final DateTime dateTime;

  /// Callback, вызывающийся при удалении.
  final VoidCallback onDelete;

  /// Callback, вызывающийся при выборе даты и времени.
  final OnDateTimeSelected onSelect;

  /// Флаг, сигнализирующий о том, выбрано ли время.
  bool get isDateTimeSelected => dateTime != null;

  SelectTimeItem(
    this.icon,
    this.title,
    this.dateTime, {
    @required this.onDelete,
    @required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDateTimeSelected
          ? null
          : () async {
              final dateTime = await showDialog(
                context: context,
                child: DateTimeSelectorDialog(),
              );
              if (dateTime != null) {
                onSelect(dateTime);
              }
            },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: icon,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                isDateTimeSelected ? _dateFormat.format(dateTime) : title,
                style: TextStyle(color: _getTextColor()),
              ),
            ),
          ),
          if (isDateTimeSelected)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }

  Color _getTextColor() {
    if (!isDateTimeSelected) {
      return null;
    }
    return dateTime.isAfter(DateTime.now()) ? Colors.green : Colors.red;
  }
}
