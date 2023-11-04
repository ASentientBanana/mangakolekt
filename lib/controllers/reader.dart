import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:path/path.dart';

class ReaderController {
  late List<BookPage> pages;
  int _pageNumber = 0;
  List<int> currentPages = [0];
  bool isDoublePageView = false;
  ScaleTo scaleTo = ScaleTo.height;
  bool isRightToLeftMode = false;
  List<int> widePages = [];
  String? bookDirPath;
  Future<void> Function(String, int)? updateBookCb;

  ReaderController(
      {required List<BookPage> pageList, this.bookDirPath, this.updateBookCb}) {
    pages = pageList;
    _pageNumber = pageList.length;
  }

  //Check if in bounds and return 0 if not return -1 or 1 depending on direction.
  int checkBounds(PageAction pa) {
    final _currentPages = [...currentPages];
    _currentPages.sort();
    final isNext = pa == PageAction.next;
    if (isNext && _currentPages[_currentPages.length - 1] == pages.length - 1) {
      return 1;
    } else if (!isNext && _currentPages[0] <= 0) {
      return -1;
    }
    return 0;
  }

  Future<void> bookAction(int direction) async {
    if (updateBookCb == null || bookDirPath == null) {
      return;
    }
    updateBookCb!(bookDirPath!, direction);
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
    final isNext = pa == PageAction.next;
    //check for bounds
    final boundResult = checkBounds(pa);
    if (boundResult == -1) {
      bookAction(boundResult);
      return;
    } else if (boundResult == 1) {
      bookAction(boundResult);
      return;
    }

    // Increment and decrement pages
    currentPages = currentPages.map((i) {
      final adder = (isDoublePageView ? 2 : 1) * (!isNext ? -1 : 1);
      return i + adder;
    }).toList();
  }
}
