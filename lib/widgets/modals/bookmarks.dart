import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarksBody.dart';

void showBookmarksDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    //   pageBuilder: (context, animation, secondaryAnimation) => BookmarksBody(),
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: const EdgeInsets.all(0),
        scrollable: true,
        content: BookmarksBody(
          dismissCb: () => Navigator.pop(context),
        ),
      );
    },
  );
}
