import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
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
    final isDeleted =
        await deleteLibbyIndex(widget.item.mapString, widget.index);
    final dbList = await readAppDB();
    if (isDeleted) {
      // ignore: use_build_context_synchronously
      context.read<LibraryBloc>().add(SetLibs(libs: dbList));
      // ignore: use_build_context_synchronously
      context.read<LibraryBloc>().add(Reset());
    } else {
      print("file not deleted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contestraints) {
      return Row(
        children: [
          SizedBox(
            // width: contestraints.maxWidth * 0.7,
            // constraints: const BoxConstraints(minWidth: 400),
            width: contestraints.maxWidth *
                (contestraints.maxWidth > 130 ? 0.7 : 0.5),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                ),
                onPressed: () {
                  context.read<LibraryBloc>().add(SetCover(cover: widget.item));
                },
                child: Text(widget.item.name, overflow: TextOverflow.ellipsis)),
          ),
          PopupMenuButton(
              color: Theme.of(context).colorScheme.secondary,
              itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: "test",
                      child: const Text('Edit'),
                      onTap: () {},
                    ),
                    PopupMenuItem<String>(
                      value: "test",
                      child: const Text('Refresh'),
                      onTap: () {},
                    ),
                    PopupMenuItem<String>(
                      value: "test",
                      child: const Text("Delete"),
                      onTap: () => handleDeleteFromLib(context),
                    )
                  ])
        ],
      );
    });
  }
}
