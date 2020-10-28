import 'package:flutter/material.dart' as m;
import 'package:meta/meta.dart';
import 'package:todos/data/repositories/todos_repository/models/theme.dart';
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

  Branch copyWith({String id, Theme theme, String title}) {
    return Branch(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      title: title ?? this.title,
    );
  }
}
