import 'package:vibration/vibration.dart';

/// Функции для работы с вибрацией.
abstract class VibrationUtils {
  /// Запускает вибрацию на [milliseconds] миллисекунд.
  ///
  /// Возвращает true, если получилось запустить вибрацию.
  static Future<bool> vibrate(int milliseconds) async {
    if (await Vibration.hasVibrator() &&
        await Vibration.hasCustomVibrationsSupport()) {
      await Vibration.vibrate(duration: milliseconds);
      return true;
    }
    return false;
  }
}
