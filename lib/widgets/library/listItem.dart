import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:path/path.dart' as p;
import 'package:mangakolekt/util/lib.dart';
import 'package:path_provider/path_provider.dart';

class LibListItem extends StatefulWidget {
  final LibraryElement item;
  final int index;

  const LibListItem({Key? key, required this.item, required this.index})
      : super(key: key);

  @override
  _LibListItemState createState() => _LibListItemState();
}

class _LibListItemState extends State<LibListItem> {
  Future<void> handleDeleteFromLib(
      BuildContext context, bool shouldSetList) async {
    final deletedPaths =
        await DatabaseMangaHelpers.deleteLibrary(widget.item.id);
    await deleteFiles(deletedPaths);

    // loading the themes to the store
    if (context.mounted) {
      // REFACTOR:
      final libBloc = context.read<LibraryBloc>();
      if (libBloc.state is! LibraryLoaded) {
        return;
      }
      final state = (libBloc.state as LibraryLoaded);
      final currentIndex = state.libStore.libIndex;
      if (currentIndex != null && state.libStore.libElements.isNotEmpty) {
        final isSelected =
            state.libStore.libElements[currentIndex].id == widget.item.id;
        libBloc.add(SetCurrentLib(index: isSelected ? -1 : currentIndex));
      }
      if (shouldSetList) {
        final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();
        libBloc.add(SetLibs(libs: mangaList));
      }
    }
  }

  Future<void> handleRefreshLib(BuildContext context) async {
    if (!context.mounted) {
      return;
    }
    await handleDeleteFromLib(context, false);
    // final path = widget.item.books.first.path;
    final out = await getGlobalCoversDir();

    final res = await ArchiveController.unpackCovers(widget.item.path, out);

    if (res == null) {
      return;
    }

    // Add manga to Manga table in db
    // REFACTOR:
    final id = await DatabaseMangaHelpers.addLibrary(
        libraryPath: widget.item.path, name: widget.item.name, books: res);
    final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();

    if (mangaList.isNotEmpty && context.mounted) {
      context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
      context.read<LibraryBloc>().add(const SetCurrentLib(index: -1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final theme = Theme.of(context);
      final GlobalKey _menuKey = GlobalKey();
      return Row(
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
                context.read<LibraryBloc>().add(
                      SetCurrentLib(index: widget.index),
                    );
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
                onTap: () => handleDeleteFromLib(context, true),
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
