import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
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

  Widget listBuilder(BuildContext context, LibraryState state) {
    if (state is LibraryLoaded) {
      //Check if empty list to remove the side panel
      if (state.libStore.libList.isEmpty) {
        return const SizedBox.shrink();
      }
      final List<LibListItem> list = [];
      final numberOfBooks = state.libStore.libList.length;

      for (var i = 0; i < numberOfBooks; i++) {
        list.add(LibListItem(item: state.libStore.libList[i], index: i - 1));
      }

      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                style: BorderStyle.solid,
                width: 2),
          ),
        ),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: list,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: listBuilder,
    );
  }
}
