import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/reader_page.dart';
import '../models/book.dart';
import '../util/util.dart';

class ReaderSingle extends StatefulWidget {
  final Book book;
  ReaderSingle({Key? key, required this.book}) : super(key: key);
  @override
  _ReaderGridState createState() => _ReaderGridState();
}

class _Page {
  PageEntry entry;
  int index;
  _Page({required this.entry, required this.index});
}

class _ReaderGridState extends State<ReaderSingle> {
  int numberOfPages = 0;
  bool isDoublePageView = false;
  bool isRightToLeftMode = false;
  List<_Page> pages = [];
  _Page? currentPage;

  @override
  initState() {
    int i = 0;
    pages = widget.book.pages.map((e) {
      i++;
      return _Page(entry: e, index: i - 1);
    }).toList();
    if (widget.book.pages.isNotEmpty) {
      currentPage = pages[0];
    }
    super.initState();
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

  Future<List<Image>> getPages() async {
    return [];
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
        body: Row(
          children: [
            SizedBox(
              width: 100,
              child: ListView(
                children: pages
                    .map((e) => SizedBox(
                          width: 100,
                          height: 100,
                          child: FractionallySizedBox(
                            heightFactor: 1,
                            // height: 100,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentPage = e;
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: e.index == currentPage!.index
                                            ? Border.all(
                                                color: Colors.red,
                                                width: 5,
                                                style: BorderStyle.solid)
                                            : null),
                                    child: e.entry.image),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Expanded(child: Center(child: currentPage?.entry.image))
          ],
        ));
  }
}
