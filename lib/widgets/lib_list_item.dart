import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library.dart';

class LibListItem extends StatefulWidget {
  final String item;

  LibListItem({Key? key, required this.item}) : super(key: key);

  @override
  _LibListItemState createState() => _LibListItemState(item: item);
}

class _LibListItemState extends State<LibListItem> {
  final String item;

  _LibListItemState({required this.item});

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              context.read<LibBloc>().setPath(item);
            },
            child: Text(item)),
        PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    value: "test",
                    child: const Text('Edit'),
                    onTap: () {
                      print("test");
                    },
                  ),
                  PopupMenuItem<String>(
                    value: "test",
                    child: const Text('Delete'),
                    onTap: () {
                      print("test");
                    },
                  )
                ])
      ],
    );
  }
}
