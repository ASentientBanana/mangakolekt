import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/widgets/appbar/backButton.dart';
import 'package:mangakolekt/widgets/reader/single_image.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:flutter/services.dart';

class MangaReader extends StatefulWidget {
  Book book;
  final int id;
  Future<void> Function(String, int) updateBook;
  MangaReader(
      {Key? key,
      required this.book,
      required this.updateBook,
      required this.id})
      : super(key: key);
  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  final _focusNode = FocusNode();

  late ReaderController readerController;

  final ScrollController _scrollController = ScrollController();

  void handleScrollAnimation(int index) {
    const int pageImageHeight = 130;
    // To allow the selected element to be roughly in the middle.
    const int offset = 4;

    _scrollController.animateTo(((index - offset) * pageImageHeight).toDouble(),
        duration: const Duration(milliseconds: 100), curve: Curves.linear);
  }

  void handleMouseClick(PointerEvent ev) {
    int left = 1;
    int right = 2;
    setState(() {
      if (ev.buttons == left) {
        readerController.incrementPage();
      } else if (ev.buttons == right) {
        readerController.decrementPage();
      }
      handleScrollAnimation(readerController.getCurrentPages()[0]);
    });
  }

  bool handleKeyPress(KeyEvent ev) {
    if (ev is KeyUpEvent) return false;
    setState(() {
      if (nextKeyMap.contains(ev.logicalKey)) {
        readerController.incrementPage();
      } else if (prevKeyMap.contains(ev.logicalKey)) {
        readerController.decrementPage();
      }
      handleScrollAnimation(readerController.getCurrentPages()[0]);
    });
    return false;
  }

  void handlePreviewClick(int pageIndex) {
    setState(() {
      readerController.goToPage(pageIndex);
    });
  }

  @override
  dispose() {
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(handleKeyPress);
  }
  // TODO: Add this with a debounce
  // Future<void> startIsolate() async {
  //   RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  //   BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  //   await compute(
  //       (message) =>
  //           DatabaseMangaHelpers.setCurrentManga(message[0], message[1]),
  //       [widget.id, readerController.getCurrentPages()[0]]);
  // }

  @override
  initState() {
    readerController = ReaderController(
      updateBookCb: widget.updateBook,
      id: widget.id,
      bookDirPath: widget.book.path,
      pageList: widget.book.pages.asMap().entries.map((e) {
        return BookPage(entry: e.value, index: e.key);
      }).toList(),
    );
    ServicesBinding.instance.keyboard.addHandler(handleKeyPress);
    // compute((s){},'');
    // startIsolate();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.name),
        leading: CustomBackButton(),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                readerController.toggleViewMode();
              });
            },
            child: Text(
              readerController.isDoublePageView ? "Single page" : "Double page",
              style: TEXT_STYLE_NORMAL,
            ),
          ),
          TextButton(
            //FIX:
            onPressed: readerController.isDoublePageView
                ? () {
                    setState(() {
                      readerController.toggleReadingDirection();
                    });
                  }
                : null,
            child: Text(
              readerController.isRightToLeftMode
                  ? "Right to left"
                  : "Left to Right",
              style: readerController.isDoublePageView
                  ? TEXT_STYLE_NORMAL
                  : TEXT_STYLE_DISABLED,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                readerController.toggleScale();
              });
            },
            child: Text(
              readerController.scaleTo == ScaleTo.width
                  ? "Scale to height"
                  : "Scale to width",
              style: readerController.isDoublePageView
                  ? TEXT_STYLE_DISABLED
                  : TEXT_STYLE_NORMAL,
            ),
          ),
        ],
      ),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              color: Theme.of(context).colorScheme.background,
              child: ListPreview(
                  readerController: readerController,
                  scoreController: _scrollController,
                  onTap: handlePreviewClick),
            ),
            // I dont like this but it seems the most intuitive way to do this.
            Container(
              color: Theme.of(context).colorScheme.background,
              width: MediaQuery.of(context).size.width - 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // children: [Text(readerController.pages.length.toString())],
                children: (readerController.isRightToLeftMode
                        ? readerController.getCurrentPages()
                        : readerController.getCurrentPages().reversed.toList())
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        flex: 1,
                        child: Listener(
                          onPointerDown: handleMouseClick,
                          child: SingleImage(
                              isDouble:
                                  readerController.getCurrentPages().length ==
                                      2,
                              index: e.key,
                              image:
                                  readerController.pages[e.value].entry.image,
                              scaleTo: readerController.scaleTo),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
    // return
  }
}
