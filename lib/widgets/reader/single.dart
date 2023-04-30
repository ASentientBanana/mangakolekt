import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader/double_page_veiw.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:mangakolekt/widgets/reader/single_image.dart';

import '../../models/book.dart';

const TextStyle TEXT_STYLE_NORMAL   = TextStyle(color: Colors.white);
const TextStyle TEXT_STYLE_DISABLED = TextStyle(color: Colors.grey);

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
  ScaleTo scaleTo = ScaleTo.height;

  final ScrollController _scrollController = ScrollController();


  void handleScrollAnimation(double index) {
    int pageImageHeight = 110;
    // Adding currentPages.length ~/ 2 to keep the scroll location
    // int he middle of the scroll container
    double offset = (index + currentPages.length ~/ 2);

    if (isDoublePageView) {
      // Lets not overdo it in double page view.
      offset -= 1;
    }

    _scrollController.animateTo(offset * pageImageHeight,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
  }

  void handleChangePageView() {
    if (isDoublePageView) {
      setPagesSingle();
    } else {
      setPagesDouble();
    }
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
      scaleTo = ScaleTo.height;
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
    // No point of viewing the single page reversed.
    if (!isDoublePageView) {
      return;
    }

    setState(() {
      isRightToLeftMode = !isRightToLeftMode;
    });
  }

  void handleMouseClick(PointerEvent ev) {
    int left = 1;
    int right = 2;

    if (ev.buttons == left) {
      nextPage();
    } else if (ev.buttons == right) {
      prevPage();
    }
  }

  bool handleKeyPress(KeyEvent ev) {
    if (ev is KeyUpEvent) return false;

    if ([LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowUp]
        .contains(ev.logicalKey)) {
      prevPage();
    } else if ([
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.space
    ].contains(ev.logicalKey)) {
      nextPage();
    }
    return false;
  }

  void nextPage() {
      if (currentPages.last.index == pages.last.index) return;
      setState(() {
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

  void prevPage() {
      if (currentPages.first.index == 0) return;
      setState(() {
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

  void toggleImageScaling() {
    setState(() {
      // Force height scale for double page view.
      if (isDoublePageView) {
        scaleTo = ScaleTo.height;
        return;
      }

      scaleTo = scaleTo == ScaleTo.width
          ? ScaleTo.height
          : ScaleTo.width;
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
    ServicesBinding.instance.keyboard.addHandler(handleKeyPress);
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
    ServicesBinding.instance.keyboard.removeHandler(handleKeyPress);
  }

  Future<List<Image>> getPages() async {
    return [];
  }

  Iterable<Widget> buildPreview() {
    List<Widget> images = currentPages
        .map((e) =>
        Expanded(
            flex: 1,
            child: Listener(
                onPointerDown: handleMouseClick,
                child: SingleImage(
                    image: e.entry.image,
                    scaleTo: scaleTo))))
        .toList();


    return isRightToLeftMode
      ? images.reversed
      : images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.book.name),
          actions: [
            TextButton(
              onPressed: handleChangePageView,
              child: Text(
                isDoublePageView
                    ? "Single page"
                    : "Double page",
                style: TEXT_STYLE_NORMAL,
              ),
            ),
            TextButton(
              onPressed: switchDirection,
              child: Text(
                isRightToLeftMode
                    ? "Left to Right"
                    : "Right to left",
                style: isDoublePageView
                    ? TEXT_STYLE_NORMAL
                    : TEXT_STYLE_DISABLED,
              ),
            ),
            TextButton(
              onPressed: toggleImageScaling,
              child: Text(
                scaleTo == ScaleTo.width
                    ? "Scale to height"
                    : "Scale to width",
                style: isDoublePageView
                    ? TEXT_STYLE_DISABLED
                    : TEXT_STYLE_NORMAL,
              ),
            ),
          ],
        ),
        body: BlocBuilder<ReaderBloc, ReaderState>(
          builder: (context, state) {
            return RawKeyboardListener(
                autofocus: true,
                focusNode: _focusNode,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ListPreview(
                          pages: pages.toList(),
                          scoreController: _scrollController,
                          currentPages: currentPages,
                          onTap: handlePreviewClick),
                    ),
                    ...buildPreview()
                  ],
                ));
          },
        ));
  }
}
