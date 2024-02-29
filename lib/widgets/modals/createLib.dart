import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/modals/createLib/createLibBody.dart';
import 'package:mangakolekt/widgets/modals/help/helpBody.dart';

void showCreateLibDialog(BuildContext context, String dir) {
  showDialog(
    barrierDismissible: false,
    //   pageBuilder: (context, animation, secondaryAnimation) => BookmarksBody(),
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.all(0),
        scrollable: true,
        content: CreateLibBody(selectedDir: dir),
      );
    },
  );
}
