import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/widgets/dragAndDropManga.dart';
import 'package:mangakolekt/widgets/library/gridItem.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LibGrid extends StatefulWidget {
  const LibGrid({super.key});

  @override
  State<LibGrid> createState() => _LibGridState();
}

class _LibGridState extends State<LibGrid> {
  final libraryStore = locator<LibraryStore>();
  int? id;

  int calculateSize(double w) {
    if (w < 1000) {
      return 1;
    } else if (w > 1700) {
      return 4;
    } else if (w > 1000 && w < 1400) {
      return 2;
    } else if (w > 1400 && w < 1700) {
      return 3;
    }
    return 2;
  }

  List<Widget> filterList(String _search, List<GridItem> list) {
    if (libraryStore.searchTerm.isEmpty) {
      return list;
    }
    return list
        .where((element) => element.item.name
            .toLowerCase()
            .contains(libraryStore.searchTerm.toLowerCase()))
        .toList();
  }

  // Widget observerBuilderHandler(BuildContext context, String term) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.orange,
      padding: const EdgeInsets.all(30),
      child: Observer(builder: (context) {
        double width = MediaQuery.of(context).size.width;

        if (libraryStore.library.isEmpty) {
          return DragAndDropSurface();
        }

        if (libraryStore.selectedCoverIndex == null) {
          return DragAndDropSurface();
        }

        final covers = libraryStore.library[libraryStore.selectedCoverIndex!];
        final gridItems = sortCoversNumeric(covers.books)
            .map((e) => GridItem(item: e))
            .toList();
        return Scrollbar(
          radius: Radius.zero,
          child: GridView.count(
            primary: true,
            crossAxisCount: calculateSize(width),
            mainAxisSpacing: 100,
            crossAxisSpacing: 10,
            children: filterList(libraryStore.searchTerm, gridItems),
          ),
        );
      }),
    );
  }
}
