import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class TodoStep {
  final String id;

  final bool wasCompleted;

  final String body;

  TodoStep({
    String id,
    bool wasCompleted,
    @required this.body,
  })  : id = id ?? Uuid().v4(),
        wasCompleted = wasCompleted ?? false,
        assert(body != null);

  TodoStep copyWith({String id, bool wasCompleted, String body}) {
    return TodoStep(
      id: id ?? this.id,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      body: body ?? this.body,
    );
  }
}
