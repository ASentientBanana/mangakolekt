import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib/list_item.dart';

class LibList extends StatefulWidget {
  const LibList({super.key});

  @override
  State<LibList> createState() => _LibListState();
}

class _LibListState extends State<LibList> {
  Future db = Future(() => null);
  @override
  void initState() {
    db = DatabaseMangaHelpers.getManga();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.tertiary,
      padding: const EdgeInsets.all(30),
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          // final _db = readAppDB();
          if (state is LibraryLoaded) {
            int index = 0;
            final list = state.libStore.libList.map((e) {
              index++;
              return LibListItem(item: e, index: index - 1);
            }).toList();
            return SizedBox(
              width: 200,
              child: Column(children: list),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
