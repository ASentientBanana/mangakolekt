import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';

class ReaderController {
  late List<BookPage> pages;
  int _pageNumber = 0;
  List<int> currentPages = [0];
  bool isDoublePageView = false;
  ScaleTo scaleTo = ScaleTo.height;
  bool isRightToLeftMode = false;
  HashMap<int, bool> widePages = HashMap();

  ReaderController({required List<BookPage> pageList}) {
    pages = pageList;
    _pageNumber = pageList.length;

    // create a list of wide pages
    // for (var page in pageList) {
    //   if (page.entry.image.width == null || page.entry.image.height == null) {
    //     continue;
    //   }
    //   if (page.entry.image.width! > page.entry.image.height!) {
    //     widePages[page.index] = true;
    //   } else {
    //     widePages[page.index] = false;
    //   }
    // }
  }

  toggleScale() {
    if (scaleTo == ScaleTo.height) {
      scaleTo = ScaleTo.width;
    } else {
      scaleTo = ScaleTo.height;
    }
  }

  updatePages(List<BookPage> newPages) {
    pages = newPages;
  }

  incrementPage() {
    pageAction(PageAction.next);
  }

  decrementPage() {
    pageAction(PageAction.previous);
  }

  checkWideView() {
    print(widePages);
  }

  goToPage(int pageIndex) {
    if (isDoublePageView) {
      if (pageIndex == _pageNumber - 1) {
        currentPages[0] = pages[_pageNumber - 2].index;
        currentPages[1] = pages[_pageNumber - 1].index;
      } else {
        currentPages[0] = pages[pageIndex].index;
        currentPages[1] = pages[pageIndex + 1].index;
      }
    } else {
      currentPages[0] = pages[pageIndex].index;
    }
  }

  toggleReadingDirection() {
    isRightToLeftMode = !isRightToLeftMode;
    currentPages = currentPages.reversed.toList();
  }

  toggleViewMode() {
    isDoublePageView = !isDoublePageView;
    if (isDoublePageView) {
      //check if last page
      if (currentPages[0] == _pageNumber - 1) {
        currentPages[0] = _pageNumber - 2;
        currentPages.add(_pageNumber - 1);
      } else {
        currentPages.add(currentPages[0] + 1);
      }
    } else {
      currentPages.removeAt(1);
    }
  }

  void pageAction(PageAction pa) {
    checkWideView();
    final pageLen = pages.length;
    // Direction check
    final isNext = pa == PageAction.next;
    if (isNext) {
      if (currentPages.last == pages.last.index) return;
    } else {
      if (currentPages.first == 0) return;
    }

    final dIndex = (isNext ? 2 : -2);
    final sIndex = (isNext ? 1 : -1);

    if (isDoublePageView) {
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
  }
}
