import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Класс с функциями для работы с файловой системой.
abstract class FileSystemUtils {
  /// Копирует файл по пути [path] в локалькую директорию.
  ///
  /// Возвращает путь к новому файлу.
  static Future<String> copyToLocal(String path) async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final directoryPath = documentDirectory.path;
    final extension = p.extension(path);
    final oldFile = File(path);
    final newPath = '$directoryPath/${Uuid().v4()}$extension';
    final newFile = await oldFile.copy(newPath);
    return newFile.path;
  }

  /// Удаляет файл по пути [path].
  static Future<void> deleteFile(String path) async {
    return await File(path).delete();
  }

  /// Переносит файл по пути [path] в кеш.
  ///
  /// Возвращает путь к файлу в кеше.
  static Future<String> moveToCache(String path) async {
    final cacheDirectory = await getTemporaryDirectory();
    final filename = p.basename(path);
    final oldFile = File(path);
    final newPath = '${cacheDirectory.path}/$filename';
    try {
      await oldFile.rename(newPath);
    } on FileSystemException catch (_) {
      await oldFile.copy(newPath);
      await oldFile.delete();
    }
    return newPath;
  }
}
