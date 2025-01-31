import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/input.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/util/reader.dart';
import 'package:mangakolekt/widgets/appbar/readerBarMobile.dart';
import 'package:mangakolekt/widgets/reader/currentPageIndexView.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:mangakolekt/widgets/reader/singleImage.dart';

class MangaReaderMobile extends StatefulWidget {
  final ReaderController readerController;
  final int initialPage;
  final int libraryId;
  const MangaReaderMobile(
      {super.key,
      required this.readerController,
      required this.initialPage,
      required this.libraryId});

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

    final bm = await DatabaseMangaHelpers.bookmark(BookmarkEvent(
        page: readerController.getCurrentPages().first,
        path: readerController.book.path,
        book: readerController.book.id ?? -1,
        library: widget.libraryId));

    setState(() {
      bookmarks = bm;
      disableBookmarkButton = false;
    });
  }

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

  List<Widget> renderPages(Size size) {
    // A more verbose page rendering way.
    final List<int> pageIndexes;

    final List<Widget> pages = [];
    final List<Map<String, double>> aspects = [];

    //check if double page view is toggled
    if (readerController.isRightToLeftMode) {
      pageIndexes = readerController.getCurrentPages();
    } else {
      pageIndexes = readerController.getCurrentPages().reversed.toList();
    }

    // Calculate new aspect ratio
    for (var imageIndex in pageIndexes) {
      final img = readerController.pages[imageIndex].entry.image;
      final w = img.width ?? 1;
      final h = img.height ?? 1;
      final isWide = w > h;
      final ar = isWide ? w / h : h / w;
      final area = w * h;
      aspects.add({
        "area": area,
        "aspect": ar,
      });
    }

    //simplest way to iterate aspects
    int imageIndex = 0;
    // 1.3 is a magic number arrived at with testing
    final imgWidth = ((size.width * 1.3) / pageIndexes.length);
    for (var pageIndex in pageIndexes) {
      final imgHeight = imgWidth / (aspects[imageIndex]["aspect"] ?? 1);

      // Image(
      //   image: readerController.pages[imageIndex].entry.image.image,
      //   height: imgWidth,
      //   width:  imgHeight,
      //   alignment: setAliment(readerController.isDoublePageView, count),
      // )
      pages.add(
        SingleImage(
          isDouble: readerController.isDoublePageView,
          onDrag: handleDragEnd,
          image: readerController.pages[pageIndex].entry.image,
          imageIndex: imageIndex,
          size: Size(imgHeight, imgWidth),
        ),
      );
      imageIndex++;
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

    final size = MediaQuery.of(context).size;
    return Focus(
      // This removes tab select for buttons in the screen to
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: Scaffold(
        extendBodyBehindAppBar: isHidden,
        backgroundColor: colorScheme.surface,
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: renderPages(size),
                      ),
                    ),
                  ),
                  Positioned(
                      width: size.width,
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
