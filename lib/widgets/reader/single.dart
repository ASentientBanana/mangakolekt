import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';

import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader/double_page_veiw.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:mangakolekt/widgets/reader/single_image.dart';
import '../../models/book.dart';
// import '../../util/util.dart';
import 'package:flutter/services.dart';

class ReaderSingle extends StatefulWidget {
  final OldBook book;
  const ReaderSingle({Key? key, required this.book}) : super(key: key);
  @override
  _ReaderGridState createState() => _ReaderGridState();
}

class _ReaderGridState extends State<ReaderSingle> {
  int numberOfPages = 0;
  bool isDoublePageView = false;
  bool isRightToLeftMode = false;
  List<BookPage> pages = [];
  List<BookPage> currentPages = [];
  final _focusNode = FocusNode();
  bool _keyPressed = false;
  ScaleTo scaleTo = ScaleTo.height;

  final ScrollController _scrollController = ScrollController();

  Map<LogicalKeyboardKey, Function> keyMap = {};

  _ReaderGridState() {
    // load keymaps
    keyMap[LogicalKeyboardKey.space] = nextPage;
    keyMap[LogicalKeyboardKey.arrowRight] = nextPage;
    keyMap[LogicalKeyboardKey.arrowLeft] = prevPage;
    keyMap[LogicalKeyboardKey.arrowDown] = nextPage;
    keyMap[LogicalKeyboardKey.arrowUp] = prevPage;
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
        BookPage p = currentPages[0];
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
      final p = currentPages[0];
      currentPages[0] = currentPages[1];
      currentPages[1] = p;
    });
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

  void handlePreviewClick(int pageIndex) {
    setState(() {
      if (isDoublePageView) {
        if (pageIndex == pages.length - 1) {
          currentPages[0] = pages[pages.length - 2];
          currentPages[1] = pages[pages.length - 1];
        } else {
          currentPages[0] = pages[pageIndex];
          currentPages[1] = pages[pageIndex + 1];
        }
      } else {
        currentPages[0] = pages[pageIndex];
      }
    });
  }

  @override
  initState() {
    int i = 0;
    pages = widget.book.pages.map((e) {
      i++;
      return BookPage(entry: e, index: i - 1);
    }).toList();
    if (widget.book.pages.isNotEmpty) {
      if (!isDoublePageView) {
        currentPages.add(pages[0]);
      } else {
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
                isDoublePageView: true,
              ))
          .toList();
    } else {
      // switchReadingDirection(list);
      return list
          .map((e) => ReaderPage(
                item: e,
                isDoublePageView: true,
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
    // print(context.read<ReaderBloc>().state.copyWith());

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: ListPreview(
                      pages: pages,
                      scoreController: _scrollController,
                      currentPages: currentPages,
                      onTap: handlePreviewClick),
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
