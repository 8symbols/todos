import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class Step {
  final String id;

  final bool wasCompleted;

  final String body;

  Step({
    String id,
    bool wasCompleted,
    @required this.body,
  })  : id = id ?? Uuid().v4(),
        wasCompleted = wasCompleted ?? false,
        assert(body != null);
}
