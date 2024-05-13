import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/platform.dart';

class LibListItem extends StatefulWidget {
  final LibraryElement item;
  final int index;

  final libraryStore = locator<LibraryStore>();

  LibListItem({Key? key, required this.item, required this.index})
      : super(key: key);

  @override
  _LibListItemState createState() => _LibListItemState();
}

class _LibListItemState extends State<LibListItem> {
  final libraryStore = locator<LibraryStore>();
  final _navigationService = locator<NavigationService>();

  Future<void> handleDeleteFromLib(bool shouldSetList) async {
    final deletedPaths =
        await DatabaseMangaHelpers.deleteLibrary(widget.item.id);
    await deleteFiles(deletedPaths);

    final newList = [...libraryStore.library];
    newList.removeWhere((element) => element.id == widget.item.id);
    libraryStore.setLibrary(newList);
    libraryStore.selectCover(null);
  }

  Future<void> handleRefreshLib(BuildContext context) async {
    final name = widget.item.name;
    final path = widget.item.path;
    // final path = widget.item.books.first.path;
    final out = await getGlobalCoversDir();

    final res = await ArchiveController.unpackCovers(widget.item.path, out);

    if (!context.mounted) {
      return;
    }
    await handleDeleteFromLib(false);

    if (res == null) {
      return;
    }

    // Add manga to Manga table in db
    await DatabaseMangaHelpers.addLibrary(
        libraryPath: path, name: name, books: res);
    final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();

    if (mangaList.isNotEmpty) {
      libraryStore.setLibrary(mangaList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final theme = Theme.of(context);
      final GlobalKey _menuKey = GlobalKey();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            // padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.tertiary, width: 2),
            ),
            width:
                constraints.maxWidth * (constraints.maxWidth > 130 ? 0.7 : 0.5),
            child: OutlinedButton(
              onPressed: () async {
                libraryStore.selectCover(widget.index);
                if (isMobile()) {
                  _navigationService.navigateTo('/grid', null);
                }
              },
              child: Center(
                child: Text(
                  widget.item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ),
          PopupMenuButton(
            color: Theme.of(context).colorScheme.background,
            key: _menuKey,
            icon: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                child: const Text("Delete"),
                onTap: () => handleDeleteFromLib(true),
              ),
              PopupMenuItem<String>(
                child: const Text("Refresh"),
                onTap: () => handleRefreshLib(context),
              )
            ],
          )
        ],
      );
    });
  }
}
