import 'package:floor/floor.dart';

/// Конвертер [DateTime] для Floor.
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return databaseValue == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value?.millisecondsSinceEpoch;
  }
}
