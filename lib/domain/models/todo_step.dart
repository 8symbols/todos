import 'package:uuid/uuid.dart';

class TodoStep {
  final String id;

  final bool wasCompleted;

  final String title;

  TodoStep(
    this.title, {
    String id,
    this.wasCompleted = false,
  })  : id = id ?? Uuid().v4(),
        assert(title != null),
        assert(wasCompleted != null);

  TodoStep copyWith({String id, bool wasCompleted, String title}) {
    return TodoStep(
      title ?? this.title,
      id: id ?? this.id,
      wasCompleted: wasCompleted ?? this.wasCompleted,
    );
  }
}
