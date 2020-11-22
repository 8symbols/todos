import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:todos/domain/models/branch_theme.dart';

/// Конвертер [BranchTheme] для Floor.
class BranchThemeConverter extends TypeConverter<BranchTheme, Uint8List> {
  @override
  BranchTheme decode(Uint8List bytes) {
    final byteData = bytes.buffer.asByteData();
    return BranchTheme(
      Color(byteData.getUint32(bytes.offsetInBytes)),
      Color(byteData.getUint32(bytes.offsetInBytes + 4)),
    );
  }

  @override
  Uint8List encode(BranchTheme theme) {
    final bytes = Uint8List(8);
    bytes.buffer.asByteData()
      ..setUint32(0, theme.primaryColor.value)
      ..setUint32(4, theme.secondaryColor.value);
    return bytes;
  }
}
