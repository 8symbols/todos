import 'package:flutter/material.dart' as m;
import 'package:meta/meta.dart';
import 'package:todos/repositories/todos_repository/models/theme.dart';
import 'package:uuid/uuid.dart';

class Branch {
  final String id;

  final String title;

  final ColorTheme theme;

  Branch({
    String id,
    Theme theme,
    @required this.title,
  })  : id = id ?? Uuid().v4(),
        theme = theme ?? ColorTheme(m.Colors.amber),
        assert(title != null);
}
