import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';

class Image {
  final String id;

  final String path;

  Image({
    String id,
    @required this.path,
  })  : id = id ?? Uuid().v4(),
        assert(path != null);
}
