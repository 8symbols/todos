import 'package:flutter/material.dart';
import 'package:todos/presentation/widgets/trembling_item.dart';

/// Виджет с кнопкой удаления в углу.
class DeletableItem extends StatefulWidget {
  /// Виджет, который можно удалить.
  final Widget child;

  /// Отступ кнопки закрытия от правой и верхней сторон.
  final double closeOffset;

  /// Callback на удаление.
  final VoidCallback onDelete;

  /// Можно ли удалить виджет.
  final bool isDeletionPossible;

  const DeletableItem({
    @required this.child,
    @required this.onDelete,
    this.isDeletionPossible = false,
    this.closeOffset = 0.0,
  });

  @override
  _DeletableItemState createState() => _DeletableItemState();
}

class _DeletableItemState extends State<DeletableItem> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final child = KeyedSubtree(key: _key, child: widget.child);

    return Stack(
      overflow: Overflow.visible,
      children: [
        widget.isDeletionPossible ? TremblingItem(child: child) : child,
        if (widget.isDeletionPossible)
          Positioned(
            right: widget.closeOffset,
            top: widget.closeOffset,
            child: SizedBox(
              height: 20.0,
              width: 20.0,
              child: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                shape: CircleBorder(),
                child: const FittedBox(
                  child: Icon(Icons.close, color: Colors.white),
                ),
                onPressed: widget.onDelete,
              ),
            ),
          ),
      ],
    );
  }
}
