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

  Step copyWith({String id, bool wasCompleted, String body}) {
    return Step(
      id: id ?? this.id,
      wasCompleted: wasCompleted ?? this.wasCompleted,
      body: body ?? this.body,
    );
  }
}
