import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/navigation.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/files.dart';

class LibraryDrawer extends StatelessWidget {
  LibraryDrawer({Key? key}) : super(key: key);
  final _navigationService = locator<NavigationService>();

  final List<NavigationItem> items = [];

  void handlePickFile() async {
      final file = await pickFile();
      if (file != null) {
        _navigationService.navigateTo('/reader', {"id": 0, "path": file});
      }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.primary,
      // child: Padding(
      // padding: const EdgeInsets.only(top: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationItem(
            onPressed: handlePickFile,
            child: const Text("Open"),
          ),
          NavigationItem(
            onPressed: () => _navigationService.navigateTo('/settings', {}),
            child: const Text("Settings"),
          ),
          NavigationItem(
            onPressed: () => _navigationService.navigateTo('/bookmarks', {}),
            child: const Text("Bookmarks"),
          ),
          NavigationItem(
            onPressed: () => _navigationService.navigateTo('/help', {}),
            child: const Text("Help"),
          ),
        ],
      ),
      // ),
    );
  }
}
