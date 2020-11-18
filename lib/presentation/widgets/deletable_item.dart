import 'package:flutter/material.dart';

/// Виджет с кнопкой удаления в углу.
class DeletableItem extends StatelessWidget {
  /// Виджет, который можно удалить.
  final Widget child;

  /// Отступ кнопки закрытия от правой и верхней сторон.
  final double closePosition;

  /// Callback на удаление.
  final VoidCallback onDelete;

  const DeletableItem({
    @required this.child,
    @required this.onDelete,
    this.closePosition = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: closePosition,
          top: closePosition,
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: RaisedButton(
              padding: const EdgeInsets.all(2.0),
              shape: CircleBorder(),
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              child: const FittedBox(
                child: Icon(Icons.close, color: Colors.white),
              ),
              onPressed: onDelete,
            ),
          ),
        ),
      ],
    );
  }
}
