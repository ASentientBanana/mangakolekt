import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/widgets/lib/list_item.dart';

class LibList extends StatefulWidget {
  const LibList({super.key});

  @override
  State<LibList> createState() => _LibListState();
}

class _LibListState extends State<LibList> {
  Future db = Future(() => null);
  final ScrollController _firstController = ScrollController();

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
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            stops: [.01, .99],
            radius: 2.0,
            focalRadius: .7,
            // focal: Alignment.bottomCenter,
            center: Alignment.bottomLeft,
            // transform: const GradientRotation(12),
            colors: [Color.fromARGB(128, 36, 71, 105), Color(0xFF081822)],
          ),
          border: Border(
            right: BorderSide(
                color: colorScheme.tertiary,
                style: BorderStyle.solid,
                width: 2),
          ),
        ),
        child: SizedBox(
          width: SIDEBAR_WIDTH,
          // child: ListView(children: list),
          child: Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.right,
            radius: Radius.zero,
            thumbVisibility: true,
            controller: _firstController,
            child: ListView.builder(
              controller: _firstController,
              itemCount: list.length ?? 0,
              // crossAxisAlignment: CrossAxisAlignment.center,
              itemBuilder: (context, i) => list[i],
            ),
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
