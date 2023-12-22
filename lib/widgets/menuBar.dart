import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigation_service.dart';
import 'package:mangakolekt/util/files.dart';

class MangaMenuBar extends StatelessWidget {
  Widget child;
  MangaMenuBar({Key? key, required this.child}) : super(key: key);

  final _navigationService = locator<NavigationService>();

  Future<void> pickFileHandler() async {
    final file = await pickFile();

    if (file != null) {
      _navigationService.navigateTo('/reader', {"id": 0, "path": file});
    }
  }

  void quitHandler() {
    // TODO: This is going to be a problem for mac os, it is not allowed
    SystemNavigator.pop();
  }

  Future<void> pickDirHandler(BuildContext context) async {
    final dir = await pickDirectory();
    if (dir != null) {
      // TODO: FIX WARRNING ABOUT CONTEXT
      context.read<LibraryBloc>().add(ToggleAddToLibModal(path: dir));
    }
  }

  void showInProgressMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "In progress",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: MenuBar(
            style: MenuStyle(
                backgroundColor:
                    MaterialStatePropertyAll(colorScheme.background)),
            children: [
              SubmenuButton(
                menuChildren: [
                  MenuItemButton(
                    onPressed: pickFileHandler,
                    child: const Text("Open"),
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
                onPressed: () => showInProgressMessage(context),
                child: const Text("Bookmarks"),
              ),
              MenuItemButton(
                onPressed: () => showInProgressMessage(context),
                child: const Text("Help"),
              ),
            ],
          ))
        ]),
        Expanded(
          child: child,
        )
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MenuBarWidget(
  //     barButtons: [
  //       BarButton(
  //         text: Text("File"),
  //         submenu: SubMenu(menuItems: [
  //           MenuButton(
  //             text: const Text("Open"),
  //             onTap: pickFileHandler,
  //           ),
  //           MenuButton(
  //             text: const Text("Add library"),
  //             onTap: () => pickDirHandler(context),
  //           ),
  //           const MenuButton(text: Text("Recent")),
  //           const MenuButton(text: Text("Bookmars")),
  //         ]),
  //       ),
  //       BarButton(
  //         text: Text("Settings"),
  //         submenu: SubMenu(menuItems: [
  //           MenuButton(text: Text("Do smtin")),
  //         ]),
  //       ),
  //     ],
  //     child: child,
  //   );
  // }
}
