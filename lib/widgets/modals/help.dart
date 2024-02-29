import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/modals/help/helpBody.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    //   pageBuilder: (context, animation, secondaryAnimation) => BookmarksBody(),
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.all(0),
        scrollable: true,
        content: HelpBody(),
      );
    },
  );
}
