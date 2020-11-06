import 'package:flutter/material.dart';

class TodoTimeSettingsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlatButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Напомнить'),
              onPressed: () {},
            ),
            const Divider(
              height: 2.0,
              indent: 44.0,
              thickness: 2.0,
            ),
            FlatButton.icon(
              icon: const Icon(Icons.event),
              label: const Text('Добавить дату выполнения'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
