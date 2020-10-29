import 'package:flutter/material.dart';

class BranchTheme {
  final Color primaryColor;

  final Color secondaryColor;

  const BranchTheme(this.primaryColor, this.secondaryColor)
      : assert(primaryColor != null),
        assert(secondaryColor != null);
}
