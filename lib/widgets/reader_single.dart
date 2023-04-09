import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader_page.dart';
import 'package:mangakolekt/widgets/reader_single_image.dart';
import '../models/book.dart';
import '../util/util.dart';
import 'package:flutter/services.dart';

class ReaderSingle extends StatefulWidget {
  final Book book;
  const ReaderSingle({Key? key, required this.book}) : super(key: key);
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
  List<_Page> currentPages = [];
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
    keyMap[LogicalKeyboardKey.arrowDown] = nextPage;
    keyMap[LogicalKeyboardKey.arrowUp] = prevPage;
  }

  void handleScrollAnimation(double index) {
    // The 110 is image height and padding
    _scrollController.animateTo(index * 110,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  }

  void setPagesDouble() {
    setState(() {
      if (currentPages[0].index < pages.length - 2) {
        currentPages.add(pages[currentPages[0].index + 1]);
      } else {
        _Page p = currentPages[0];
        currentPages[0] = pages[p.index - 1];
        currentPages[1] = p;
      }
      isDoublePageView = true;
    });
  }

  void setPagesSingle() {
    setState(() {
      currentPages.removeAt(1);
      isDoublePageView = false;
    });
  }

  void swapReadingOrientation() {
    setState(() {
      final _p = currentPages[0];
      currentPages[0] = currentPages[1];
      currentPages[1] = _p;
    });
    // if (isDoublePageView) {
    // }
  }

  void switchDirection() {
    setState(() {
      isRightToLeftMode = !isRightToLeftMode;
    });
  }

  void nextPage(RawKeyEvent event) {
    if (event is RawKeyDownEvent && !_keyPressed) {
      if (currentPages.last.index == pages.last.index) return;
      setState(() {
        _keyPressed = true;
        if (isDoublePageView) {
          if (currentPages[1].index < pages.length - 2) {
            currentPages.replaceRange(0, 2, [
              pages[currentPages[0].index + 2],
              pages[currentPages[1].index + 2]
            ]);
          } else {
            currentPages.replaceRange(0, 2, [
              pages[currentPages[0].index + 1],
              pages[currentPages[1].index + 1]
            ]);
          }
        } else {
          if (currentPages[0].index < pages.length - 1) {
            currentPages[0] = pages[currentPages[0].index + 1];
          }
        }
        handleScrollAnimation(currentPages[0].index.toDouble());
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
      if (currentPages.first.index == 0) return;
      setState(() {
        _keyPressed = true;
        if (isDoublePageView) {
          if (currentPages[1].index > 2) {
            currentPages.replaceRange(0, 2, [
              pages[currentPages[0].index - 2],
              pages[currentPages[1].index - 2]
            ]);
          } else {
            currentPages.replaceRange(0, 2, [
              pages[currentPages[0].index - 1],
              pages[currentPages[1].index - 1]
            ]);
          }
        } else {
          if (currentPages[0].index > 0) {
            currentPages[0] = pages[currentPages[0].index - 1];
          }
        }
        handleScrollAnimation(currentPages[0].index.toDouble());
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
      if (!isDoublePageView)
        currentPages.add(pages[0]);
      else {
        if (pages.length >= 2) {
          currentPages[0] = pages[0];
          currentPages[1] = pages[1];
        } else {
          currentPages[0] = pages[0];
        }
      }
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
                  if (isDoublePageView) {
                    setPagesSingle();
                  } else {
                    setPagesDouble();
                  }
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
              onPressed: isDoublePageView ? null : toggleImageScaling,
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
                                          // currentPage = e;
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: currentPages.any(
                                                      (element) =>
                                                          element.index ==
                                                          e.index)
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
                ...isRightToLeftMode
                    ? currentPages
                        .map(
                          (e) => Expanded(
                              flex: 1,
                              child: SingleImage(
                                  image: e.entry.image,
                                  scaleTo: isDoublePageView
                                      ? ScaleTo.height
                                      : scaleTo)),
                        )
                        .toList()
                        .reversed
                    : currentPages
                        .map(
                          (e) => Expanded(
                              flex: 1,
                              child: SingleImage(
                                  image: e.entry.image,
                                  scaleTo: isDoublePageView
                                      ? ScaleTo.height
                                      : scaleTo)),
                        )
                        .toList()
              ],
            )));
  }
}
