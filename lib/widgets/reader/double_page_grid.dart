import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/reader/double_page_grid_tile.dart';

import '../../models/book.dart';
import '../../util/util.dart';

class ReaderGrid extends StatefulWidget {
  final OldBook book;
  const ReaderGrid({Key? key, required this.book}) : super(key: key);
  @override
  _ReaderGridState createState() => _ReaderGridState();
}

class _ReaderGridState extends State<ReaderGrid> {
  int numberOfPages = 0;
  bool isDoublePageView = false;
  bool isRightToLeftMode = false;
  List<PageEntry> pages = [];

  @override
  initState() {
    pages = widget.book.pages;
    super.initState();
  }

  void switchReadingDirection(list) {
    final len = list.length;

    for (var i = 0; i < len; i++) {
      if (i + 1 < len && i % 2 == 0) {
        swap(list, i, i + 1);
      }
    }
  }

  void switchDirection() {
    setState(() {
      isRightToLeftMode = !isRightToLeftMode;
      switchReadingDirection(pages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: isDoublePageView ? 2 : 1,
        primary: false,
        children: pages
            .map((e) => ReaderPage(
                  item: e,
                  isDoublePageView: true,
                ))
            .toList(),
      ),
    );
  }
}
