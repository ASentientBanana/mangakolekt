import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/models/util.dart';

class InputController {
  ReaderController rc;
  final readerScrollController = ScrollController();

  InputController({required this.rc});

  final prevKeyMap = [
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowUp,
  ];
  final nextKeyMap = [
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.space,
  ];

  scrollToTop() {
    readerScrollController.animateTo(0,
        duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  scrollToBot() {
    readerScrollController.animateTo(
        readerScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut);
  }

  scrollHalf() {
    readerScrollController.animateTo(
        readerScrollController.position.maxScrollExtent * .5,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut);
  }

  jumpToTop() {
    readerScrollController.jumpTo(0);
  }

  bool keyboard(KeyEvent ev) {
    if (ev is KeyUpEvent) return false;

    // Checking for scaled image
    if (!rc.isDoublePageView && rc.scaleTo == ScaleTo.width) {
      //Check for bound
      final isStart = readerScrollController.position.extentBefore == 0;
      final isEnd = readerScrollController.position.extentAfter == 0;

      if (readerScrollController.position.atEdge) {
        if (isStart && isEnd) {
          if (nextKeyMap.contains(ev.logicalKey)) {
            rc.incrementPage();
          } else if (prevKeyMap.contains(ev.logicalKey)) {
            rc.decrementPage();
          }
          return false;
        }
        //start of scroll
        if (isStart) {
          if (prevKeyMap.contains(ev.logicalKey)) {
            rc.decrementPage();
            jumpToTop();
            return false;
          }
          scrollHalf();
          return false;
        }

        //end of scroll
        if (isEnd) {
          if (nextKeyMap.contains(ev.logicalKey)) {
            rc.incrementPage();
            jumpToTop();
            return false;
          }
          scrollHalf();
          return false;
        }
      }
      if (nextKeyMap.contains(ev.logicalKey)) {
        scrollToBot();
      } else if (prevKeyMap.contains(ev.logicalKey)) {
        scrollToTop();
      }
      return false;
    }

    if (nextKeyMap.contains(ev.logicalKey)) {
      rc.incrementPage();
    } else if (prevKeyMap.contains(ev.logicalKey)) {
      rc.decrementPage();
    }
    return false;
  }
}
