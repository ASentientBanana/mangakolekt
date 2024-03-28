import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/widgets/library/listItem.dart';

class LibList extends StatefulWidget {
  const LibList({super.key});

  @override
  State<LibList> createState() => _LibListState();
}

class _LibListState extends State<LibList> {
  Future db = Future(() => null);
  final ScrollController _firstController = ScrollController();
  bool hidden = false;

  @override
  void initState() {
    // db = DatabaseMangaHelpers.getCovers(id:);
    super.initState();
  }

  Widget builder(BuildContext context, LibraryState state) {
    if (state is! LibraryLoaded) {
      return const SizedBox.shrink();
    }
    //Check if empty list to remove the side panel
    if (state.libStore.libElements.isEmpty) {
      return const SizedBox.shrink();
    }
    final List<LibListItem> list = [];
    final numberOfBooks = state.libStore.libElements.length;

    for (var i = 0; i < numberOfBooks; i++) {
      list.add(LibListItem(item: state.libStore.libElements[i], index: i));
    }
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          // duration: const Duration(milliseconds: 600),
          // curve: Curves.ease,
          width: 280,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              stops: [.01, 1],
              radius: 2.9,
              focalRadius: .4,
              // focal: Alignment.bottomCenter,
              center: Alignment.bottomLeft,
              // transform: const GradientRotation(12),
              colors: [Color.fromARGB(128, 36, 71, 105), Color(0xFF081822)],
            ),
            border: Border(
              right: BorderSide(
                  color: colorScheme.secondary,
                  style: BorderStyle.solid,
                  width: 2),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            // child: ListView(children: list),
            child: Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.right,
              radius: Radius.zero,
              thumbVisibility: true,
              controller: _firstController,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 40,
                ),
                controller: _firstController,
                itemCount: list.length ?? 0,
                // crossAxisAlignment: CrossAxisAlignment.center,
                itemBuilder: (context, i) => hidden ? null : list[i],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: builder,
    );
  }
}
