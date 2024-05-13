import 'dart:ffi';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateLibraryActionButton extends StatefulWidget {
  CreateLibraryActionButton({Key? key}) : super(key: key);

  @override
  State<CreateLibraryActionButton> createState() =>
      _CreateLibraryActionButtonState();
}

class _CreateLibraryActionButtonState extends State<CreateLibraryActionButton> {
  final _navigationService = locator<NavigationService>();
  bool isDisabled = false;

  Future<String?> pickDirHandler(BuildContext context) async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null || !context.mounted) {
      return null;
    }
    // showCreateLibDialog(context, dir);
    // final d = Directory(dir);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text(d.listSync().toString())));
    //  dir

    return dir;
  }

  Future<void> handleAdd(BuildContext context) async {
    setState(() {
      isDisabled = true;
    });
    if (!(await Permission.manageExternalStorage.isGranted)) {
      final result = await Permission.manageExternalStorage.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        setState(() {
          isDisabled = false;
        });
        return;
      }
    }

    if (!context.mounted) {
      setState(() {
        isDisabled = false;
      });
      return;
    }
    final dir = await pickDirHandler(context);
    if (dir == null) {
      setState(() {
        isDisabled = false;
      });
      return;
    }
    _navigationService.navigateTo("/addLibrary", {"path": dir});
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       contentPadding: const EdgeInsets.all(0),
    //       content: const Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 10),
    //           child: Text("The app is missing permisions permission")),
    //       actions: [
    //         TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text("Close")),
    //         TextButton(
    //             onPressed: () {
    //               Permission.manageExternalStorage.request();
    //             },
    //             child: Text("ok")),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
          side: const BorderSide(
              width: 3, color: Color.fromARGB(255, 238, 245, 238)),
          borderRadius: BorderRadius.circular(100)),
      backgroundColor: colorScheme.background,
      onPressed: isDisabled ? null : () => handleAdd(context),
      child: const Icon(size: 42, Icons.add),
    );
  }
}
