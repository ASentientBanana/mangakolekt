import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader/double_page_veiw.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:mangakolekt/widgets/reader/single_image.dart';

import '../../models/book.dart';

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
  List<BookPage> currentPages = [];
  final _focusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();

  void handleScrollAnimation(double index) {
    int pageImageHeight = 110;
    // Adding currentPages.length ~/ 2 to keep the scroll location
    // int he middle of the scroll container
    _scrollController.animateTo(
        (index + currentPages.length ~/ 2) * pageImageHeight,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear);
  }

  void setPagesDouble(bool isDoublePageView) {
    setState(() {
      if (currentPages[0].index < pages.length - 2) {
        currentPages.add(pages[currentPages[0].index + 1]);
      } else {
        BookPage p = currentPages[0];
        currentPages[0] = pages[p.index - 1];
        currentPages[1] = p;
      }
    });
  }

  void setPagesSingle() {
    setState(() {
      currentPages.removeAt(1);
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
    final bloc = context.read<ReaderBloc>();
    if (bloc.state is! ReaderLoaded) return;
    bloc.add(ToggleIsRightToLeftMode());
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
    final state = context.read<ReaderBloc>().state as ReaderLoaded;

    if (currentPages.last.index == pages.last.index) return;
    setState(() {
      if (state.bookView.isDoublePageView!) {
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
    final state = context.read<ReaderBloc>().state as ReaderLoaded;
    setState(() {
      if (state.bookView.isDoublePageView!) {
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

  void handlePreviewClick(int pageIndex, bool isDoublePageView) {
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
        if (!state.bookView.isDoublePageView!) {
          currentPages.add(pages[0]);
        } else {
          if (pages.length >= 2) {
            currentPages[0] = pages[0];
            currentPages[1] = pages[1];
          } else {
            currentPages[0] = pages[0];
          }
        }
      });
    });

    super.initState();
  }

  @override
  dispose() {
    // _focusNode.dispose();
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(handleKeyPress);
  }

  Future<List<Image>> getPages() async {
    return [];
  }

  List<Widget> renderPages(bool isRightToLeftMode) {
    final state = BlocProvider.of<ReaderBloc>(context).state;
    if (state is! ReaderLoaded) return [];

    print("render::");

    final list = currentPages
        .map(
          (e) => Expanded(
              flex: 1,
              child: SingleImage(
                  image: e.entry.image,
                  scaleTo: state.bookView.isDoublePageView!
                      ? ScaleTo.height
                      : state.bookView.scaleTo)),
        )
        .toList();
    return isRightToLeftMode ? list : list.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderBloc, ReaderState>(builder: (context, state) {
      final bookView = (state as ReaderLoaded).bookView;

      final isDoublePageView = bookView.isDoublePageView!;
      final isRightToLeftMode = bookView.isRightToLeftMode!;
      final scaleTo = bookView.scaleTo;
      print("RtL: $isRightToLeftMode");

      return Scaffold(
        appBar: AppBar(
          title: Text("$widget.book.name"),
          actions: [
            TextButton(
              onPressed: () {
                if (isDoublePageView!) {
                  setPagesSingle();
                } else {
                  setPagesDouble(isDoublePageView!);
                }
                context.read<ReaderBloc>().add(ToggleDoublePageViewMode());
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
              onPressed: isDoublePageView
                  ? null
                  : () => context.read<ReaderBloc>().add(ToggleScaleTo()),
              child: Text(
                scaleTo == ScaleTo.height ? "Scale to height" : "Scale to with",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: RawKeyboardListener(
          autofocus: true,
          focusNode: _focusNode,
          child: Listener(
            onPointerDown: handleMouseClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: ListPreview(
                      pages: pages.toList(),
                      scoreController: _scrollController,
                      currentPages: currentPages,
                      onTap: null),
                ),
                ...renderPages(isRightToLeftMode),
              ],
            ),
          ),
        ),
      );
    });
  }
}
