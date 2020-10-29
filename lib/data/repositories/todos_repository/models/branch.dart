import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:todos/data/repositories/todos_repository/models/branch_theme.dart';
import 'package:uuid/uuid.dart';

class Branch {
  final String id;

  final String title;

  final BranchTheme theme;

  Branch({
    String id,
    BranchTheme theme,
    @required this.title,
  })  : id = id ?? Uuid().v4(),
        theme = theme ?? BranchTheme(Color(0xFF6202EE), Color(0xFFB5C9FD)),
        assert(title != null);

  Branch copyWith({String id, BranchTheme theme, String title}) {
    return Branch(
      id: id ?? this.id,
      theme: theme ?? this.theme,
      title: title ?? this.title,
    );
  }
}
