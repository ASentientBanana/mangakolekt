import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader_page.dart';
import '../models/book.dart';
import '../util/util.dart';
import 'package:flutter/services.dart';

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
  final _focusNode = FocusNode();
  bool _keyPressed = false;
  ScaleTo scaleTo = ScaleTo.height;

  final ScrollController _scrollController = ScrollController();

  final Map<LogicalKeyboardKey, Function> keyMap = {};

  _ReaderGridState() {
    // load keymaps
    keyMap[LogicalKeyboardKey.space] = nextPage;
    keyMap[LogicalKeyboardKey.arrowRight] = nextPage;
    keyMap[LogicalKeyboardKey.arrowLeft] = prevPage;
    // keyMap[LogicalKeyboardKey.arrowDown] = nextPage;
    // keyMap[LogicalKeyboardKey.arrowUp] = prevPage;
  }

  void switchDirection() {
    setState(() {
      isRightToLeftMode = !isRightToLeftMode;
      switchReadingDirection(pages);
    });
  }

  void handleScrollAnimation(double index) {
    // The 110 is image height and padding
    _scrollController.animateTo(index * 110,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  }

  void nextPage(RawKeyEvent event) {
    if (event is RawKeyDownEvent && !_keyPressed) {
      setState(() {
        _keyPressed = true;
        if (currentPage != null && currentPage!.index < pages.length - 1) {
          currentPage = pages[currentPage!.index + 1];
          handleScrollAnimation(currentPage!.index.toDouble());
        }
      });
    }
    if (event is RawKeyUpEvent && _keyPressed) {
      setState(() {
        _keyPressed = false;
      });
    }
  }

  void prevPage(RawKeyEvent event) {
    if (event is RawKeyDownEvent && !_keyPressed) {
      setState(() {
        _keyPressed = true;
        if (currentPage != null && currentPage!.index > 0) {
          currentPage = pages[currentPage!.index - 1];
          handleScrollAnimation(currentPage!.index.toDouble());
        }
      });
    }
    if (event is RawKeyUpEvent && _keyPressed) {
      setState(() {
        _keyPressed = false;
      });
    }
  }

  void toggleImageScaling() {
    setState(() {
      if (scaleTo == ScaleTo.height) {
        scaleTo = ScaleTo.width;
      } else {
        scaleTo = ScaleTo.height;
      }
    });
  }

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

  @override
  dispose() {
    _focusNode.dispose();
    super.dispose();
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
              ),
            ),
            TextButton(
              onPressed: isDoublePageView ? switchDirection : null,
              child: Text(
                isRightToLeftMode ? "Left to Right" : "Right to left",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: toggleImageScaling,
              child: Text(
                scaleTo == ScaleTo.height ? "Scale to height" : "Scale to with",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: RawKeyboardListener(
            autofocus: true,
            onKey: (event) {
              final action = keyMap[event.logicalKey];
              if (action != null) {
                action(event);
              }
            },
            focusNode: _focusNode,
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: ListView(
                    controller: _scrollController,
                    children: pages
                        .map(
                          (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SizedBox(
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
                                              border: e.index ==
                                                      currentPage!.index
                                                  ? Border.all(
                                                      color: Colors.red,
                                                      width: 5,
                                                      style: BorderStyle.solid)
                                                  : null),
                                          child: e.entry.image),
                                    ),
                                  ),
                                ),
                              )),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: currentPage != null
                        ? scaleTo == ScaleTo.width
                            ? SingleChildScrollView(
                                child: Image(
                                image: currentPage!.entry.image.image,
                                fit: BoxFit.cover,
                              ))
                            : currentPage?.entry.image
                        : const Text(""),
                  ),
                ),
              ],
            )));
  }
}
