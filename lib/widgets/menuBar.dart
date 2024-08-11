import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/modals/bookmarks.dart';
import 'package:mangakolekt/widgets/modals/createLib.dart';
import 'package:mangakolekt/widgets/modals/help.dart';
import 'package:mangakolekt/widgets/modals/settings.dart';
import 'package:mangakolekt_archive_lib/mangakolekt_archive_lib.dart' as mkh;
import 'package:mangakolekt_archive_lib/mangakolekt_archive_zip/mangakolekt_archive_cover.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MangaMenuBar extends StatelessWidget {
  final Widget child;
  MangaMenuBar({Key? key, required this.child}) : super(key: key);

  final _navigationService = locator<NavigationService>();
  final textEditingController = TextEditingController();
  final libraryStore = locator<LibraryStore>();

  Future<void> pickFileHandler() async {
    // final file = await pickFile();
    try {
      mangakolektUnzipArchiveCover(
          "/home/petar/bigboy/Manga/Holyland/Holyland - Volume_01.cbz",
          '/home/petar/Documents/mangakolekt/');
    } catch (e) {
      print("FFI ERROR");
      print(e);
    }

    // if (file != null) {
    //   _navigationService.navigateTo('/reader', {"id": 0, "path": file});
    // }
    return;
  }

  void quitHandler() {
    // TODO: This is going to be a problem for mac os, it is not allowed
    SystemNavigator.pop();
  }

  Future<void> pickDirHandler(BuildContext context,
      {bool readDir = false}) async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null || !context.mounted) {
      return;
    }
    if (readDir) {
      // _navigationService.navigateTo(, arguments)
      return;
    }
    showCreateLibDialog(context, dir);
    //  dir
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.secondary, width: 2),
            ),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
                flex: 8,
                child: MenuBar(
                  children: [
                    SubmenuButton(
                      menuChildren: [
                        MenuItemButton(
                          onPressed: pickFileHandler,
                          child: const Text("Open"),
                        ),
                        MenuItemButton(
                          onPressed: () =>
                              pickDirHandler(context, readDir: true),
                          child: const Text("Open directory"),
                        ),
                        MenuItemButton(
                          onPressed: () => pickDirHandler(context),
                          child: const Text("Add library"),
                        ),
                        MenuItemButton(
                          onPressed: quitHandler,
                          child: const Text("Quit"),
                        )
                      ],
                      child: const Text("File"),
                    ),
                    MenuItemButton(
                      onPressed: () => showSettingsDialog(context),
                      child: const Text("Settings"),
                    ),
                    MenuItemButton(
                      onPressed: () => showBookmarksDialog(context),
                      child: const Text("Bookmarks"),
                    ),
                    MenuItemButton(
                      onPressed: () => showHelpDialog(context),
                      child: const Text("Help"),
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    height: 24,
                    padding: const EdgeInsets.only(right: 20),
                    child: Material(
                        child: TextField(
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5),
                        hintText: "Search books",
                        hintStyle: TextStyle(color: colorScheme.onPrimary),
                        fillColor: colorScheme.background,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              width: 1, color: colorScheme.onPrimary),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              width: 1, color: colorScheme.onPrimary),
                        ),
                      ),
                      onChanged: (s) {
                        libraryStore.search(s);
                        // context
                        //     .read<LibraryBloc>()
                        //     .add(SearchLib(searchTerm: s));
                      },
                      controller: textEditingController,
                    )),
                  ),
                  Positioned(
                    top: 4,
                    right: 25,
                    child: Icon(
                      Icons.search_sharp,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        Expanded(
          child: child,
        )
      ],
    );
  }
}
