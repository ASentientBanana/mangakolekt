import 'package:flutter/material.dart';
import 'package:mangakolekt/models/dialog.dart';

class MangaDialog extends StatelessWidget {
  String content;
  DialogType type;
  MangaDialog({super.key, this.type = DialogType.info, required this.content});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: const Text("A problem occurred"),
      insetPadding: EdgeInsets.all(30),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Ok"),
        )
      ],
    );
  }
}
