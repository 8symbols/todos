import 'package:flutter/material.dart';

/// Диалог для выбора даты и времени.
///
/// Возвращает [DateTime] или null.
class DateTimeSelectorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
          child: const Text('Через неделю (18:00)'),
          onPressed: () {
            final now = DateTime.now();
            Navigator.of(context)
                .pop(DateTime(now.year, now.month, now.day + 1, 18));
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
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
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
