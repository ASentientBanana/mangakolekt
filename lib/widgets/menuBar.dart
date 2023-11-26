import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigation_service.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:menu_bar/menu_bar.dart';

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

  Future<void> pickDirHandler(BuildContext context) async {
    final dir = await pickDirectory();
    if (dir != null) {
      // TODO: FIX WARRNING ABOUT CONTEXT
      context.read<LibraryBloc>().add(ToggleAddToLibModal(path: dir));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MenuBarWidget(
      barButtons: [
        BarButton(
          text: Text("File"),
          submenu: SubMenu(menuItems: [
            MenuButton(
              text: const Text("Open"),
              onTap: pickFileHandler,
            ),
            MenuButton(
              text: const Text("Add library"),
              onTap: () => pickDirHandler(context),
            ),
            const MenuButton(text: Text("Recent")),
            const MenuButton(text: Text("Bookmars")),
          ]),
        ),
        BarButton(
          text: Text("Settings"),
          submenu: SubMenu(menuItems: [
            MenuButton(text: Text("Do smtin")),
          ]),
        ),
      ],
      child: child,
    );
  }
}
