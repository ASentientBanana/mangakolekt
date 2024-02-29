import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/modals/settings/settingsBody.dart';

void showSettingsDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.all(0),
        scrollable: true,
        content: SettingsBody(
          dismissCb: () => Navigator.pop(context),
        ),
      );
    },
  );
}
