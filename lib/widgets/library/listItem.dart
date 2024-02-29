import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
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
  void handleDeleteFromLib(BuildContext context) async {
    // await deleteLib(widget.item.path);
    // DatabaseMangaHelpers.deleteManga(widget.item.id).then((value) {
    //   context.read<LibraryBloc>().add(RemoveBook(id: widget.item.id));
    // });
  }

  Future<void> handleRefreshLib(BuildContext context) async {
    if (!context.mounted) {
      return;
    }
    // final mangaList = await refreshLib(item: widget.item);
    // if (mangaList != null) {
    //   context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
    // }
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
                onTap: () => handleDeleteFromLib(context),
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
