import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library.dart';
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
      context.read<LibBloc>().setLibList(dbList);
      // ignore: use_build_context_synchronously
      context.read<LibBloc>().resetPath();
    } else {
      print("file not deleted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 140),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              onPressed: () {
                context.read<LibBloc>().setPath(widget.item);
              },
              child: Text(widget.item.name, overflow: TextOverflow.ellipsis)),
        ),
        // '${item.name.length <= 15 ? item.name : item.name.substring(0, 10)}...')),
        PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: "test",
                    child: const Text('Edit'),
                    onTap: () {
                      // print(item.mapString);
                    },
                  ),
                  PopupMenuItem<String>(
                    value: "test",
                    child: const Text('Refresh'),
                    onTap: () {},
                  ),
                  PopupMenuItem<String>(
                    value: "test",
                    child: const Text('Delete'),
                    onTap: () => handleDeleteFromLib(context),
                  )
                ])
      ],
    );
  }
}
