import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

class TodoImage {
  final String id;

  final String path;

  TodoImage({
    String id,
    @required this.path,
  })  : id = id ?? Uuid().v4(),
        assert(path != null);

  TodoImage copyWith({String id, String path}) {
    return TodoImage(
      id: id ?? this.id,
      path: path ?? this.path,
    );
  }
}
