import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/input.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/util/reader.dart';
import 'package:mangakolekt/widgets/appbar/readerBarMobile.dart';
import 'package:mangakolekt/widgets/reader/curentPageIndexView.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:mangakolekt/widgets/reader/singleImage.dart';

class MangaReaderMobile extends StatefulWidget {
  final ReaderController readerController;
  final int initialPage;
  const MangaReaderMobile(
      {Key? key, required this.readerController, required this.initialPage})
      : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReaderMobile>
    with SingleTickerProviderStateMixin {
  int dx = 0;
  List<int> bookmarks = [];
  bool isHidden = false;
  bool disableBookmarkButton = false;

  late final AnimationController appBarAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  late ReaderController readerController;
  late InputController inputController =
      InputController(rc: widget.readerController);

  void handlePreviewClick(int pageIndex) {
    setState(() {
      readerController.goToPage(pageIndex);
    });
  }

  @override
  dispose() {
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
      // handleScrollAnimation();
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
    // appBarAnimationController =
    super.initState();
  }

  Future<void> bookmark() async {
    setState(() {
      disableBookmarkButton = true;
    });

    final bm = await DatabaseMangaHelpers.bookmark(
        bookID: readerController.book.id ?? -1,
        path: readerController.book.path,
        page: readerController.getCurrentPages().first);

    setState(() {
      bookmarks = bm;
      disableBookmarkButton = false;
    });
  }

  void handleDragStart(DragStartDetails ds) {}
  void handleDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      setState(() {
        readerController.decrementPage();
      });
      // handleScrollAnimation();
    } else if (details.primaryVelocity! < 0) {
      setState(() {
        readerController.incrementPage();
        // handleScrollAnimation();
      });
    }
  }

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
          child: GestureDetector(
            onHorizontalDragEnd: handleDragEnd,
            child: SingleImage(
                readerScrollController: null,
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
    bool isBookmark = false;
    try {
      isBookmark = bookmarks.contains(readerController.getCurrentPages().first);
    } catch (e) {
      isBookmark = false;
    }

    final width = MediaQuery.of(context).size.width;
    return Focus(
      // This removes tab select for buttons in the screen to
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: Scaffold(
        extendBodyBehindAppBar: isHidden,
        backgroundColor: colorScheme.background,
        drawer: Drawer(
          backgroundColor: colorScheme.primary,
          child: ListPreview(
            sc: null,
            readerController: readerController,
            onTap: handlePreviewClick,
          ),
        ),
        appBar: SlidingAppBar(
            controller: appBarAnimationController,
            isBookmarkedColor: colorScheme.tertiary,
            isNotBookmarkedColor: colorScheme.onPrimary,
            readerController: readerController,
            isBookmark: isBookmark,
            bookmark: disableBookmarkButton ? () {} : bookmark,
            isHidden: isHidden,
            set: setState),
        body: Center(
          // heightFactor: isHidden ? 0.5 : 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // I don't like this but it seems the most intuitive way to do this.
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isHidden = !isHidden;
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      // color: Theme.of(context).colorScheme.background,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: renderPages(),
                      ),
                    ),
                  ),
                  Positioned(
                      width: width,
                      bottom: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // color: colorScheme.primary,
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readerController.decrementPage();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.fast_rewind,
                                    color: colorScheme.secondary,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      readerController.incrementPage();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.fast_forward,
                                    color: colorScheme.secondary,
                                  )),
                            ],
                          ),
                          CurrentPageIndexView(
                            currentPages: readerController
                                .getCurrentPages()
                                .map((e) => e + 1)
                                .join('-'),
                            totalPages:
                                readerController.pages.length.toString(),
                          )
                        ],
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
