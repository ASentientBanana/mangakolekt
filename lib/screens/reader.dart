import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/input.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:mangakolekt/util/reader.dart';
import 'package:mangakolekt/widgets/appbar/readerbar.dart';
import 'package:mangakolekt/widgets/reader/curentPageIndexView.dart';
import 'package:mangakolekt/widgets/reader/singleImage.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:flutter/services.dart';

class MangaReader extends StatefulWidget {
  final ReaderController readerController;
  final int initialPage;
  const MangaReader(
      {Key? key, required this.readerController, required this.initialPage})
      : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  final _focusNode = FocusNode();
  List<int> bookmarks = [];

  late ReaderController readerController;
  late InputController inputController =
      InputController(rc: widget.readerController);

  final ScrollController _scrollController = ScrollController();

  void handleScrollAnimation() {
    final index = readerController.getCurrentPages().first;
    const int pageImageHeight = 130;
    // To allow the selected element to be roughly in the middle.
    const int offset = 4;

    _scrollController.animateTo(((index - offset) * pageImageHeight).toDouble(),
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void handleMouseClick(PointerEvent ev) {
    if (isMobile()) {
      return;
    }
    int left = 1;
    int right = 2;
    setState(() {
      if (ev.buttons == left) {
        readerController.incrementPage();
        handleScrollAnimation();
      } else if (ev.buttons == right) {
        readerController.decrementPage();
        handleScrollAnimation();
      }
    });
  }

  bool handleKeyPress(KeyEvent ev) {
    bool res = false;
    setState(() {
      res = inputController.keyboard(ev);
      handleScrollAnimation();
    });
    return res;
  }

  void handlePreviewClick(int pageIndex) {
    setState(() {
      readerController.goToPage(pageIndex);
    });
  }

  @override
  dispose() {
    ServicesBinding.instance.keyboard.removeHandler(handleKeyPress);
    inputController.readerScrollController.dispose();
    super.dispose();
  }

  Future<List<int>> getBookmarks() async {
    final bookmarks = await DatabaseMangaHelpers.getBookmarkPagesFromPath(
        path: readerController.book.path);

    return bookmarks;
  }

  Future<void> initBook() async {
    readerController = widget.readerController;
    // readerController.goToPage(widget.initialPage);
    final bm = await getBookmarks();
    setState(() {
      bookmarks = bm;
      readerController.goToPage(widget.initialPage);
      handleScrollAnimation();
    });
  }

  //TODO:REPLACE
  Future<void> findNextBook() async {
    // final x = await checkForNextBook(widget.readerController.book.path);
    final map = await checkForNextBook(widget.readerController.book.path);

    if (map['prev'] != null) {
      widget.readerController.prevBookPath = map['prev']!;
    }
    if (map['next'] != null) {
      widget.readerController.nextBookPath = map['next']!;
    }
  }

  @override
  initState() {
    initBook();
    findNextBook();
    if (!isMobile()) {
      ServicesBinding.instance.keyboard.addHandler(handleKeyPress);
    }
    super.initState();
  }

  // TODO: REPLACE
  Future<void> bookmark() async {
    final isBookmark =
        bookmarks.contains(readerController.getCurrentPages().first);
    if (!isBookmark) {
      await DatabaseMangaHelpers.addBookmark(
          book: readerController.book.id ?? -1,
          path: readerController.book.path,
          page: readerController.getCurrentPages().first);
    } else {
      await DatabaseMangaHelpers.removeBookmark(
          book: readerController.book.id ?? -1,
          page: readerController.getCurrentPages().first);
    }
    final bm = await getBookmarks();
    setState(() {
      bookmarks = bm;
    });
  }

  // TODO: REPLACE
  List<Widget> renderPages() {
    // A more verbose page rendering way.
    final List<int> pageIndexes;
    //check if double page view is toggled
    if (readerController.isRightToLeftMode) {
      pageIndexes = readerController.getCurrentPages();
    } else {
      pageIndexes = readerController.getCurrentPages().reversed.toList();
    }
    final List<Widget> pages = [];

    for (var i = 0; i < pageIndexes.length; i++) {
      pages.add(
        Expanded(
          // flex: 1,
          child: Listener(
            onPointerDown: handleMouseClick,
            child: SingleImage(
                readerScrollController: inputController.readerScrollController,
                isDouble: readerController.getCurrentPages().length == 2,
                index: i,
                image: readerController.pages[pageIndexes[i]].entry.image,
                scaleTo: readerController.scaleTo),
          ),
        ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBookmark =
        bookmarks.contains(readerController.getCurrentPages().first);
    return Focus(
      // This removes tab select for buttons in the screen to
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: Scaffold(
        appBar: ReaderAppbar(
            isBookmarkedColor: colorScheme.tertiary,
            isNotBookmarkedColor: colorScheme.onPrimary,
            readerController: readerController,
            isBookmark: isBookmark,
            bookmark: bookmark,
            set: setState),
        body: KeyboardListener(
          focusNode: _focusNode,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SIDEBAR_WIDTH,
                color: Theme.of(context).colorScheme.background,
                child: ListPreview(
                    readerController: readerController,
                    sc: _scrollController,
                    onTap: handlePreviewClick),
              ),
              // I dont like this but it seems the most intuitive way to do this.
              Stack(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    width: MediaQuery.of(context).size.width - SIDEBAR_WIDTH,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: renderPages(),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: CurrentPageIndexView(
                          currentPages: readerController
                              .getCurrentPages()
                              .map((e) => e + 1)
                              .join('-'),
                          totalPages: readerController.pages.length.toString(),
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    ); // return
  }
}
