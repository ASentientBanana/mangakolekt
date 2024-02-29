import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/modals/help/helpBody.dart';

Future<void> showContinueReadingDialog(BuildContext context, manga) async {
  //Get last read

  //if least read is null return
  // if(){

  // }
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
