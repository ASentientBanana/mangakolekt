import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/widgets/reader/single_image.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';
import 'package:flutter/services.dart';

class MangaReader extends StatefulWidget {
  Book book;
  MangaReader({Key? key, required this.book}) : super(key: key);
  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  final _focusNode = FocusNode();

  late ReaderController readerController;

  final ScrollController _scrollController = ScrollController();

  void handleScrollAnimation(int index) {
    const int pageImageHeight = 110;
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
      handleScrollAnimation(readerController.currentPages[0]);
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
      handleScrollAnimation(readerController.currentPages[0]);
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

  @override
  initState() {
    readerController = ReaderController(
      pageList: widget.book.pages.asMap().entries.map((e) {
        return BookPage(entry: e.value, index: e.key);
      }).toList(),
    );
    ServicesBinding.instance.keyboard.addHandler(handleKeyPress);
    super.initState();
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
            SizedBox(
              width: 100,
              child: ListPreview(
                  readerController: readerController,
                  scoreController: _scrollController,
                  onTap: handlePreviewClick),
            ),
            // I dont like this but it seems the most intuitive way to do this.
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: readerController.currentPages
                    .map(
                      (e) => Expanded(
                        flex: 1,
                        child: Listener(
                          onPointerDown: handleMouseClick,
                          child: SingleImage(
                              image: readerController.pages[e].entry.image,
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
