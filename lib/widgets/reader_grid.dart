import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/reader_page.dart';

import '../models/book.dart';
import '../util/util.dart';

class ReaderGrid extends StatefulWidget {
  final Book book;
  ReaderGrid({Key? key, required this.book}) : super(key: key);
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

  List<Widget> createDoubleView(List<PageEntry> list) {
    if (!isRightToLeftMode) {
      return list
          .map((e) => ReaderPage(
                item: e,
                isGridView: true,
              ))
          .toList();
    } else {
      // switchReadingDirection(list);
      return list
          .map((e) => ReaderPage(
                item: e,
                isGridView: true,
              ))
          .toList();
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.book.name),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    if (isRightToLeftMode) {
                      isRightToLeftMode = false;
                      switchReadingDirection(pages);
                    }
                    isDoublePageView = !isDoublePageView;
                  });
                },
                child: const Text(
                  "Double page",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: isDoublePageView ? switchDirection : null,
                child: Text(
                  isRightToLeftMode ? "Left to Right" : "Right to left",
                  style: const TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Container(
          child: Center(
            child: GridView.count(
              crossAxisCount: isDoublePageView ? 2 : 1,
              primary: false,
              children: createDoubleView(pages),
            ),
          ),
        ));
  }
}
