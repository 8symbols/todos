import 'package:flutter/material.dart';

/// Карта с изображениями задачи.
class TodoImagesCard extends StatelessWidget {
  final List<String> todoImages = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // TODO: Build images.
            SizedBox(
              height: 100.0,
              width: 60.0,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                  child: const Icon(
                    Icons.attachment,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            )
          ],
        ),
      ),
    );
  }
}
