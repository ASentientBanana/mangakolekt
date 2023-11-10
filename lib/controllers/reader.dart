import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';

class ReaderController {
  late List<BookPage> pages;
  int pageNumber = 0;
  List<int> currentPages = [0];
  int currentPageIndex = 0;
  bool isDoublePageView = false;
  ScaleTo scaleTo = ScaleTo.height;
  bool isRightToLeftMode = false;
  String? bookDirPath;
  Future<void> Function(String, int)? updateBookCb;
  Map<int, List<List<int>>> pageMap = {0: [], 1: []};

  ReaderController(
      {required List<BookPage> pageList, this.bookDirPath, this.updateBookCb}) {
    pages = pageList;
    pageNumber = pageList.length;

    //Construct lists for single and double view
    List<List<int>> _d = [];
    pageMap[0] = pageList.map((e) => [e.index]).toList();
    final pagesLen = pageList.length;
    for (var i = 0; i < pagesLen;) {
      if (i == pagesLen - 1) {
        _d.add([i]);
        break;
      }
      final p = [i, i + 1];
      if (p.any((element) => pages[element].entry.isDouble)) {
        //2 wide pages or second page is wide
        if ((pages[i].entry.isDouble && pages[i + 1].entry.isDouble) ||
            pages[i + 1].entry.isDouble) {
          _d.add([i]);
          _d.add([i + 1]);
          i = i + 2;
          continue;
        }
        // first page is wide
        if (pages[i].entry.isDouble) {
          _d.add([i]);
          i++;
          continue;
        }
      }
      i = i + 2;
      _d.add(p);
    }

    pageMap[1] = _d;
  }

  List<int> getPages(int index) {
    if (isDoublePageView) {
      return pageMap[1]!.firstWhere((element) => element.contains(index));
    } else {
      return pageMap[0]!.firstWhere((element) => element.contains(index));
    }
  }

  void goToPage(int index) {
    currentPageIndex = index;
  }

  Future<void> bookAction(int direction) async {
    if (updateBookCb == null || bookDirPath == null) {
      return;
    }
    updateBookCb!(bookDirPath!, direction);
  }

  void toggleScale() {
    if (scaleTo == ScaleTo.height) {
      scaleTo = ScaleTo.width;
    } else {
      scaleTo = ScaleTo.height;
    }
  }

  void updatePages(List<BookPage> newPages) {
    pages = newPages;
  }

  void incrementPage() {
    pageAction(PageAction.next);
  }

  void decrementPage() {
    pageAction(PageAction.previous);
  }

  void toggleReadingDirection() {
    isRightToLeftMode = !isRightToLeftMode;
  }

  void toggleViewMode() {
    final current = getCurrentPages().first;
    final mapPointer = isDoublePageView ? 0 : 1;
    for (var i = 0; i < pageMap[mapPointer]!.length; i++) {
      if (pageMap[mapPointer]![i].contains(current)) {
        currentPageIndex = i;
        isDoublePageView = !isDoublePageView;
        return;
      }
    }
  }

  bool checkInBounds(PageAction pa) {
    if (currentPageIndex >= pageMap[isDoublePageView ? 1 : 0]!.length - 1 &&
        pa == PageAction.next) {
      return false;
    }
    if (currentPageIndex <= 0 && pa == PageAction.previous) {
      return false;
    }
    return true;
  }

  void pageAction(PageAction pa) {
    if (!checkInBounds(pa)) {
      return;
    }
    if (pa == PageAction.next) {
      currentPageIndex++;
    } else {
      currentPageIndex--;
    }
  }

  List<int> getCurrentPages() {
    return pageMap[isDoublePageView ? 1 : 0]![currentPageIndex];
  }
}
