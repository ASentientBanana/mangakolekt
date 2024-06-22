import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/widgets/homeLogo.dart';
import 'package:mangakolekt/widgets/modals/createLib.dart';

class DragAndDropSurface extends StatelessWidget {
  final _navigationService = locator<NavigationService>();

  DragAndDropSurface({Key? key}) : super(key: key);

  void onDragDoneHandler(DropDoneDetails details, BuildContext context) async {
    try {
      final target = details.files.first;
      final isFile = target.name.split('.').length > 1;
      if (isFile) {
        _navigationService
            .navigateTo('/reader', {"id": 0, "path": target.path});
      } else {
        showCreateLibDialog(context, target.path);
      }
    } catch (e) {
      print("Error ocurred during drag and drop action: \n");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: ((details) => onDragDoneHandler(details, context)),
      child: HomeLogo(
        text: "Drag a file or folder to open it or add to a library",
      ),
    );
  }
}
