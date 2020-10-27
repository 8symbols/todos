import 'package:flutter/material.dart';

abstract class Theme {}

class ColorTheme extends Theme {
  final Color color;

  ColorTheme(this.color);
}

class ImageTheme extends Theme {
  final String path;

  ImageTheme(this.path);
}
