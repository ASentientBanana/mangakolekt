import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/input.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:mangakolekt/util/reader.dart';
import 'package:mangakolekt/widgets/appbar/readerbar.dart';
import 'package:mangakolekt/widgets/reader/singleImage.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:flutter/services.dart';

class MangaReader extends StatefulWidget {
  final ReaderController readerController;
  final int initialPage;
  final int libraryId;
  const MangaReader({
    super.key,
    required this.readerController,
    required this.initialPage,
    required this.libraryId,
  });

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  final _focusNode = FocusNode();

  List<int> bookmarks = [];
  bool disableBookmarkButton = false;

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
    final bookmarks = await DatabaseMangaHelpers.getBookmarkedPagesForBook(
        book: readerController.book.id, path: readerController.book.path);

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

  Future<void> bookmark() async {
    setState(() {
      disableBookmarkButton = true;
    });

    final bm = await DatabaseMangaHelpers.bookmark(BookmarkEvent(
        page: readerController.getCurrentPages().first,
        path: readerController.book.path,
        book: readerController.book.id ?? -1,
        library: widget.libraryId));

    setState(() {
      disableBookmarkButton = false;
      bookmarks = bm;
    });
  }

  List<Widget> renderPages(Size size) {
    // A more verbose page rendering way.
    final List<int> pageIndexes;

    final List<Widget> pages = [];
    // final List<Map<String, double>> aspects = [];

    //check if double page view is toggled
    if (readerController.isRightToLeftMode) {
      pageIndexes = readerController.getCurrentPages();
    } else {
      pageIndexes = readerController.getCurrentPages().reversed.toList();
    }

    final isDouble = pageIndexes.length == 2;

    final img = readerController.pages[pageIndexes[0]].entry.image;
    final w = img.width ?? 1;
    final h = img.height ?? 1;
    final isWide = w > h;
    final aspect = isWide ? w / h : h / w;

    double imgWidth;
    if (isWide) {
      imgWidth = size.width;
    } else {
      imgWidth = size.width / 2;
    }
    final imgHeight = imgWidth * aspect;

    for (var i = 0; i < pageIndexes.length; i++) {
      final pageIndex = pageIndexes[i];
      pages.add(
        SingleImage(
          isDouble: isDouble,
          increment: handleMouseClick,
          image: readerController.pages[pageIndex].entry.image,
          imageIndex: i,
          size: Size(imgWidth, imgHeight),
          // size: Size(imgHeight, imgWidth),
        ),
      );
    }
    return pages;
  }

  Widget readerLayoutBuilder(
      BuildContext context, BoxConstraints constraints, double width) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: renderPages(Size(width, constraints.maxHeight)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final isBookmark =
        bookmarks.contains(readerController.getCurrentPages().first);
    final readerWidth = screenWidth - SIDEBAR_WIDTH;

    return Focus(
      // This removes tab select for buttons in the screen to
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ReaderAppbar(
            isBookmarkedColor: colorScheme.tertiary,
            isNotBookmarkedColor: colorScheme.onPrimary,
            readerController: readerController,
            isBookmark: isBookmark,
            bookmark: disableBookmarkButton ? null : bookmark,
            set: setState),
        body: KeyboardListener(
          focusNode: _focusNode,
          child: Row(
            children: [
              Container(
                width: SIDEBAR_WIDTH,
                color: colorScheme.surface,
                child: ListPreview(
                  readerController: readerController,
                  sc: _scrollController,
                  onTap: handlePreviewClick,
                ),
              ),
              // I dont like this but it seems the most intuitive way to do this.
              Container(
                color: colorScheme.surface,
                // color: Colors.purpleAccent,
                width: readerWidth,
                child: LayoutBuilder(
                  builder: (ctx, c) => readerLayoutBuilder(ctx, c, readerWidth),
                ),
              ),
            ],
          ),
        ),
      ),
    ); // return
  }
}
