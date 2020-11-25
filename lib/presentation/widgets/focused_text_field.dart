import 'package:flutter/material.dart';

/// [TextField], который возвращает введенный текст при потере фокуса.
class FocusedTextField extends StatefulWidget {
  /// Стиль текста.
  final TextStyle style;

  /// Декорация.
  final InputDecoration decoration;

  /// Вызывается при подтверждении ввода или потере фокуса.
  final ValueChanged<String> onSubmitted;

  /// Автофокус.
  final bool autofocus;

  /// Действие.
  ///
  /// Может быть равным [null].
  final TextInputAction textInputAction;

  /// Максимальное количество строк.
  ///
  /// Может быть равным [null]. При этом ограничение отсутствует.
  final int maxLines;

  /// Начальное значение.
  ///
  /// Может быть равным [null].
  final String initialValue;

  const FocusedTextField({
    @required this.onSubmitted,
    this.autofocus = false,
    this.decoration = const InputDecoration(),
    this.maxLines = 1,
    this.style,
    this.textInputAction,
    this.initialValue,
  });

  @override
  _FocusedTextFieldState createState() => _FocusedTextFieldState();
}

class _FocusedTextFieldState extends State<FocusedTextField> {
  String _submittedValue;

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _submittedValue = widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (isFocused) {
        if (!isFocused) {
          _submitValue(_controller.text);
        }
      },
      child: TextField(
        controller: _controller,
        decoration: widget.decoration,
        style: widget.style,
        textInputAction: widget.textInputAction,
        maxLines: null,
        onSubmitted: _submitValue,
        autofocus: widget.autofocus,
      ),
    );
  }

  void _submitValue(String value) {
    if (_submittedValue != value) {
      widget.onSubmitted(value);
      _submittedValue = value;
    }
  }
}
