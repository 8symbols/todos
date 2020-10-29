import 'package:uuid/uuid.dart';

class TodoImage {
  final String id;

  final String imagePath;

  TodoImage(
    this.imagePath, {
    String id,
  })  : id = id ?? Uuid().v4(),
        assert(imagePath != null);

  TodoImage copyWith({String id, String path}) {
    return TodoImage(
      path ?? this.imagePath,
      id: id ?? this.id,
    );
  }
}
