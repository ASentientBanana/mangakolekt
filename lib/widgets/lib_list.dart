import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/store.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib_list_item.dart';

class LibList extends StatefulWidget {
  const LibList({super.key});

  @override
  State<LibList> createState() => _LibListState();
}

class _LibListState extends State<LibList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      padding: const EdgeInsets.all(30),
      child: BlocBuilder<LibBloc, MangaStore>(
        builder: (context, snapshot) {
          return FutureBuilder(
            builder: (context, snapshot) {
              final list = snapshot.data
                  ?.map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: LibListItem(item: e),
                    ),
                  )
                  .toList();
              return SizedBox(
                width: 200,
                child: Column(
                  children: list ??
                      [const Flexible(child: Text("No libraries added"))],
                ),
              );
            },
            future: readAppDB(),
          );
        },
      ),
    );
  }
}
