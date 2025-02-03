
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateLibraryActionButton extends StatefulWidget {
  const CreateLibraryActionButton({super.key});

  @override
  State<CreateLibraryActionButton> createState() =>
      _CreateLibraryActionButtonState();
}

class _CreateLibraryActionButtonState extends State<CreateLibraryActionButton> {
  final _navigationService = locator<NavigationService>();

  Future<String?> pickDirHandler(BuildContext context) async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null || !context.mounted) {
      return null;
    }

    return dir;
  }

  Future<void> handleAdd(BuildContext context) async {
    if (!(await Permission.manageExternalStorage.isGranted)) {
      final result = await Permission.manageExternalStorage.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        return;
      }
    }

    if (!context.mounted) {
      return;
    }
    final dir = await pickDirHandler(context);
    if (dir == null) {
      return;
    }
    _navigationService.navigateTo("/addLibrary", {"path": dir});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
          side: const BorderSide(
              width: 3, color: Color.fromARGB(255, 238, 245, 238)),
          borderRadius: BorderRadius.circular(100)),
      backgroundColor: colorScheme.surface,
      onPressed: () => handleAdd(context),
      child: const Icon(size: 42, Icons.add),
    );
  }
}
