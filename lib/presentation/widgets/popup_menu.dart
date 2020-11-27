import 'package:flutter/material.dart';
import 'package:todos/presentation/models/popup_menu_item_data.dart';

/// Выпадающее меню.
class PopupMenu extends StatelessWidget {
  /// Элементы меню.
  final List<PopupMenuItemData> options;

  const PopupMenu(this.options);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupMenuItemData>(
      padding: EdgeInsets.zero,
      onSelected: (value) => value.onSelected(context),
      itemBuilder: (BuildContext context) {
        return options.map((PopupMenuItemData data) {
          return PopupMenuItem<PopupMenuItemData>(
            value: data,
            child: Row(
              children: [
                Icon(data.icon, color: Colors.black54),
                const SizedBox(width: 16),
                Expanded(child: Text(data.title)),
              ],
            ),
            // child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
