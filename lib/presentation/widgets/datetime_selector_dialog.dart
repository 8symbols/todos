import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Диалог для выбора даты и времени.
///
/// Возвращает [DateTime] или null.
class DateTimeSelectorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Выберите время'),
      children: [
        SimpleDialogOption(
          child: const Text('Сегодня (18:00)'),
          onPressed: () {
            final now = DateTime.now();
            Navigator.of(context)
                .pop(DateTime(now.year, now.month, now.day, 18));
          },
        ),
        SimpleDialogOption(
          child: const Text('Завтра (18:00)'),
          onPressed: () {
            final now = DateTime.now();
            Navigator.of(context)
                .pop(DateTime(now.year, now.month, now.day + 1, 18));
          },
        ),
        SimpleDialogOption(
          child: const Text('Через неделю (9:00)'),
          onPressed: () {
            final now = DateTime.now();
            Navigator.of(context)
                .pop(DateTime(now.year, now.month, now.day + 7, 9));
          },
        ),
        SimpleDialogOption(
          child: const Text('Выбрать время'),
          onPressed: () async {
            final time = await _pickDateTime(context);
            if (time != null) {
              Navigator.of(context).pop(time);
            }
          },
        ),
      ],
    );
  }

  Future<DateTime> _pickDateTime(BuildContext context) async {
    return Platform.isIOS || Platform.isMacOS
        ? _pickCupertinoDateTime(context)
        : _pickMaterialDateTime(context);
  }

  Future<DateTime> _pickCupertinoDateTime(BuildContext context) async {
    DateTime dateTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 216.0,
        color: CupertinoColors.white,
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            use24hFormat: true,
            onDateTimeChanged: (value) => dateTime = value,
            mode: CupertinoDatePickerMode.dateAndTime,
          ),
        ),
      ),
    );

    return dateTime;
  }

  Future<DateTime> _pickMaterialDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (date == null) {
      return null;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
