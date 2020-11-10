import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Класс с функциями для работы с файловой системой.
abstract class FileSystemHelper {
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
}
