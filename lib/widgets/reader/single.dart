import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:mangakolekt/widgets/reader/single_image.dart';

import '../../models/book.dart';

const TextStyle TEXT_STYLE_NORMAL = TextStyle(color: Colors.white);
const TextStyle TEXT_STYLE_DISABLED = TextStyle(color: Colors.grey);

typedef Toggle = void Function();

class ReaderSingle extends StatefulWidget {
  final OldBook book;
  const ReaderSingle({Key? key, required this.book}) : super(key: key);
  @override
  _ReaderGridState createState() => _ReaderGridState();
}

class _ReaderGridState extends State<ReaderSingle> {
  int numberOfPages = 0;
  List<BookPage> pages = [];
  List<int> currentPages = [];
  final _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  void handleScrollAnimation(int index) {
    const int pageImageHeight = 110;
    // To allow the selected element to be roughly in the middle.
    const int offset = 4;

    _scrollController.animateTo(((index - offset) * pageImageHeight).toDouble(),
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void setPagesDouble(bool isDoublePageView) {
    setState(() {
      //There is an error here if the final page selected in single mode and then switched to double
      if (currentPages[0] < pages.length - 2 &&
          currentPages[0] != pages.length - 1) {
        currentPages.add((pages[currentPages[0] + 1]).index);
      } else {
        int p = currentPages[0];
        currentPages[0] = pages[p - 1].index;
        currentPages[1] = p;
      }
    });
  }

  void setPagesSingle() {
    if (currentPages.length > 1) {
      setState(() {
        currentPages.removeAt(1);
      });
    }
  }

  void handlePagePreviewClick() {}

  void pageAction(PageAction pa) {
    final pageLen = pages.length;
    final state = context.read<ReaderBloc>().state as ReaderLoaded;
    // Direction check
    final isNext = pa == PageAction.next;
    if (isNext) {
      if (currentPages.last == pages.last.index) return;
    } else {
      if (currentPages.first == 0) return;
    }

    final dIndex = (isNext ? 2 : -2);
    final sIndex = (isNext ? 1 : -1);

    setState(() {
      if (state.bookView.isDoublePageView) {
        if (currentPages[1] > 2) {
          int e1;
          int e2;
          if (currentPages[1] == pageLen - 2) {
            e1 = pageLen - 2;
            e2 = pageLen - 1;
          } else {
            e1 = currentPages[0] + dIndex;
            e2 = currentPages[1] + dIndex;
          }

          currentPages.replaceRange(0, 2, [pages[e1].index, pages[e2].index]);
        } else {
          currentPages.replaceRange(0, 2, [
            pages[currentPages[0] + sIndex].index,
            pages[currentPages[1] + sIndex].index
          ]);
        }
      } else {
        if (!isNext && currentPages[0] > 0) {
          currentPages[0] = pages[currentPages[0] + sIndex].index;
        } else if (isNext && currentPages[0] < pageLen - 1) {
          currentPages[0] = pages[currentPages[0] + 1].index;
        }
      }
      handleScrollAnimation(currentPages[0]);
    });
  }

  void switchDirection() {
    final bloc = context.read<ReaderBloc>();
    if (bloc.state is! ReaderLoaded) return;
    bloc.add(ToggleIsRightToLeftMode());
  }

  void handleMouseClick(PointerEvent ev) {
    int left = 1;
    int right = 2;

    if (ev.buttons == left) {
      pageAction(PageAction.next);
    } else if (ev.buttons == right) {
      pageAction(PageAction.previous);
    }
  }

  bool handleKeyPress(KeyEvent ev) {
    if (ev is KeyUpEvent) return false;

    if (nextKeyMap.contains(ev.logicalKey)) {
      pageAction(PageAction.next);
    } else if (prevKeyMap.contains(ev.logicalKey)) {
      pageAction(PageAction.previous);
    }
    return false;
  }

  void handlePreviewClick(int pageIndex, bool isDoublePageView) {
    final pageLen = pages.length;
    setState(() {
      if (isDoublePageView) {
        if (pageIndex == pageLen - 1) {
          currentPages[0] = pages[pageLen - 2].index;
          currentPages[1] = pages[pageLen - 1].index;
        } else {
          currentPages[0] = pages[pageIndex].index;
          currentPages[1] = pages[pageIndex + 1].index;
        }
      } else {
        currentPages[0] = pages[pageIndex].index;
      }
    });
  }

  @override
  initState() {
    if (widget.book.pages.isEmpty) return;
    Future.delayed(Duration.zero, () {
      setState(() {
        final state =
            BlocProvider.of<ReaderBloc>(context).state as ReaderLoaded;
        int i = 0;

        pages = widget.book.pages.map((e) {
          i++;
          return BookPage(entry: e, index: i - 1);
        }).toList();
        if (!state.bookView.isDoublePageView) {
          currentPages.add(pages[0].index);
        } else {
          if (pages.length >= 2) {
            currentPages[0] = pages[0].index;
            currentPages[1] = pages[1].index;
          } else {
            currentPages[0] = pages[0].index;
          }
        }
      });
    });
    ServicesBinding.instance.keyboard.addHandler(handleKeyPress);
    super.initState();
  }

  @override
  dispose() {
    // _focusNode.dispose();
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(handleKeyPress);
  }

  Iterable<Widget> renderBooks(bool isRightToLeftMode) {
    final state = BlocProvider.of<ReaderBloc>(context).state;
    if (state is! ReaderLoaded) return [];
    final list = currentPages
        .map(
          (e) => Expanded(
            flex: 1,
            child: Listener(
              onPointerDown: handleMouseClick,
              child: SingleImage(
                  image: pages[e].entry.image,
                  scaleTo: state.bookView.isDoublePageView
                      ? ScaleTo.height
                      : state.bookView.scaleTo),
            ),
          ),
        )
        .toList();
    return isRightToLeftMode ? list : list.reversed;
  }

  void handleChangePageView(bool isDoublePageView) {
    if (isDoublePageView) {
      setPagesSingle();
    } else {
      setPagesDouble(isDoublePageView);
    }
    context.read<ReaderBloc>().add(ToggleDoublePageViewMode());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderBloc, ReaderState>(builder: (context, state) {
      final bookView = (state as ReaderLoaded).bookView;

      final isDoublePageView = bookView.isDoublePageView;
      final isRightToLeftMode = bookView.isRightToLeftMode;
      final scaleTo = bookView.scaleTo;

      return Scaffold(
        appBar: AppBar(
          title: Text("$widget.book.name"),
          actions: [
            TextButton(
              onPressed: () => handleChangePageView(isDoublePageView),
              child: Text(
                isDoublePageView ? "Single page" : "Double page",
                style: TEXT_STYLE_NORMAL,
              ),
            ),
            TextButton(
              onPressed: isDoublePageView ? switchDirection : null,
              child: Text(
                isRightToLeftMode ? "Left to Right" : "Right to left",
                style:
                    isDoublePageView ? TEXT_STYLE_NORMAL : TEXT_STYLE_DISABLED,
              ),
            ),
            TextButton(
              onPressed: () => context.read<ReaderBloc>().add(ToggleScaleTo()),
              child: Text(
                scaleTo == ScaleTo.width ? "Scale to height" : "Scale to width",
                style:
                    isDoublePageView ? TEXT_STYLE_DISABLED : TEXT_STYLE_NORMAL,
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
                        isDoublePage: isDoublePageView,
                        pages: pages.toList(),
                        scoreController: _scrollController,
                        currentPages: currentPages,
                        onTap: handlePreviewClick),
                  ),
                  ...renderBooks(isRightToLeftMode),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
