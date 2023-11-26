import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigation_service.dart';
import 'package:mangakolekt/util/files.dart';

class DragAndDropSurface extends StatelessWidget {
  final _navigationService = locator<NavigationService>();

  DragAndDropSurface({Key? key}) : super(key: key);

  void onDragDoneHandler(DropDoneDetails details, BuildContext context) async {
    try {
      final target = details.files.first;
      final isFile = target.name.split('.').length == 2;
      if (isFile) {
        _navigationService
            .navigateTo('/reader', {"id": 0, "path": target.path});
      } else {
        print(target.path);
        context.read<LibraryBloc>().add(ToggleAddToLibModal(path: target.path));
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
      child: Container(
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BASENJI",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Drag a file or folder to open it or add to a library",
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
