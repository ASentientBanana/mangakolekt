import 'package:flutter/material.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/widgets/library/listItem.dart';

class LibList extends StatefulWidget {
  final List<LibraryElement> libraryList;
  const LibList({super.key, required this.libraryList});

  @override
  State<LibList> createState() => _LibListState();
}

class _LibListState extends State<LibList> {
  Future db = Future(() => null);

  final ScrollController _firstController = ScrollController();
  bool hidden = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
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
              color: colorScheme.secondary, style: BorderStyle.solid, width: 2),
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
            itemCount: widget.libraryList.length,
            // crossAxisAlignment: CrossAxisAlignment.center,
            itemBuilder: (context, i) => hidden
                ? null
                : LibListItem(item: widget.libraryList[i], index: i),
          ),
        ),
      ),
    );
  }
}
