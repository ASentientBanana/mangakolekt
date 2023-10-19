import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/database/database_core.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/database/database_table.dart';
import '../../util/files.dart';

class LibListItem extends StatefulWidget {
  final BookCover item;
  final int index;

  const LibListItem({Key? key, required this.item, required this.index})
      : super(key: key);

  @override
  _LibListItemState createState() => _LibListItemState();
}

class _LibListItemState extends State<LibListItem> {
  void handleDeleteFromLib(BuildContext context) async {
    await deleteLib(widget.item.path);
    DatabaseMangaHelpers.deleteManga(widget.item.id).then((value) {
      context.read<LibraryBloc>().add(RemoveBook(id: widget.item.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        children: [
          SizedBox(
            width:
                constraints.maxWidth * (constraints.maxWidth > 130 ? 0.7 : 0.5),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
              ),
              onPressed: () {
                context.read<LibraryBloc>().add(
                      SetCover(cover: widget.item),
                    );
              },
              child: Text(widget.item.name, overflow: TextOverflow.ellipsis),
            ),
          ),
          PopupMenuButton(
              color: Theme.of(context).colorScheme.secondary,
              itemBuilder: (context) => [
                    // PopupMenuItem<String>(
                    //   value: "test",
                    //   child: const Text('Edit'),
                    //   onTap: () {},
                    // ),
                    // PopupMenuItem<String>(
                    //   value: "test",
                    //   child: const Text('Refresh'),
                    //   onTap: () {},
                    // ),
                    PopupMenuItem<String>(
                      value: "",
                      child: const Text("Delete"),
                      onTap: () => handleDeleteFromLib(context),
                    )
                  ])
        ],
      );
    });
  }
}
