import 'package:flutter/material.dart';

/// [Appbar] с поисковой строкой.
class SearchAppBar extends StatelessWidget {
  /// Подсказка в поле ввода.
  ///
  /// Может быть равным null.
  final String hintText;

  /// Callback при нажатии на кнопку "назад".
  final VoidCallback onBackPressed;

  /// Callback при вводе данных.
  final ValueChanged<String> onSubmitted;

  SearchAppBar({
    @required this.onBackPressed,
    @required this.onSubmitted,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextField(
          autofocus: true,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            prefixIconConstraints:
                const BoxConstraints.tightFor(height: 24.0, width: 48.0),
            suffixIconConstraints:
                const BoxConstraints.tightFor(height: 24.0, width: 40.0),
            prefixIcon: InkWell(
              child: const Icon(Icons.arrow_back, size: 24.0),
              onTap: onBackPressed,
            ),
            suffixIcon: const Icon(Icons.search, size: 24.0),
          ),
        ),
      ),
    );
  }
}
