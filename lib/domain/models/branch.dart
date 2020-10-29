import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';
import 'package:uuid/uuid.dart';

class Branch {
  final String id;

  final String title;

  final BranchTheme theme;

  Branch(
    this.title, {
    String id,
    this.theme = const BranchTheme(Color(0xFF6202EE), Color(0xFFB5C9FD)),
  })  : id = id ?? Uuid().v4(),
        assert(title != null),
        assert(theme != null);

  Branch copyWith({String id, BranchTheme theme, String title}) {
    return Branch(
      title ?? this.title,
      id: id ?? this.id,
      theme: theme ?? this.theme,
    );
  }
}
