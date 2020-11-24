import 'package:flutter/material.dart';

typedef OnFavoriteToggle = void Function(bool isFavorite);

/// Кнопка для добавления в избранное и удаления из него.
class FavoriteButton extends StatelessWidget {
  /// Находится ли сейчас элемент в избранном.
  final bool isFavorite;

  /// Вызывается при нажатии на кнопку.
  final OnFavoriteToggle onToggle;

  /// Цвет кнопки.
  final Color color;

  /// Размер кнопки.
  final double size;

  const FavoriteButton(
    this.isFavorite, {
    @required this.onToggle,
    this.color = Colors.orangeAccent,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: color,
        size: size,
      ),
      onPressed: () => onToggle(!isFavorite),
    );
  }
}
