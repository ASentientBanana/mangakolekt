import 'package:easy_debounce/easy_throttle.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';

class ReaderController {
  late List<BookPage> pages;
  late final Book book;

  List<int> currentPages = [0];
  int currentPageIndex = 0;
  bool isDoublePageView = false;
  ScaleTo scaleTo = ScaleTo.height;
  bool isRightToLeftMode = false;
  String? bookDirPath;
  String? nextBookPath;
  String? prevBookPath;
  void Function(String, Object?)? openBook;
  Map<int, List<List<int>>> pageMap = {0: [], 1: []};

  ReaderController({required this.book, Settings? settings}) {
    pages = book.getPageList();
    //Construct lists for single and double view
    List<List<int>> doubleViewList = [];
    pageMap[0] = pages.map((e) => [e.index]).toList();
    final pagesLen = pages.length;
    for (var i = 0; i < pagesLen;) {
      if (i == pagesLen - 1) {
        doubleViewList.add([i]);
        break;
      }
      final p = [i, i + 1];
      if (p.any((element) => pages[element].entry.isDouble)) {
        //2 wide pages or second page is wide
        if ((pages[i].entry.isDouble && pages[i + 1].entry.isDouble) ||
            pages[i + 1].entry.isDouble) {
          doubleViewList.add([i]);
          doubleViewList.add([i + 1]);
          i = i + 2;
          continue;
        }
        // first page is wide
        if (pages[i].entry.isDouble) {
          doubleViewList.add([i]);
          i++;
          continue;
        }
      }
      i = i + 2;
      doubleViewList.add(p);
    }
    pageMap[1] = doubleViewList;
  }

  List<int> getPages(int index) {
    if (isDoublePageView) {
      return pageMap[1]!.firstWhere((element) => element.contains(index));
    } else {
      return pageMap[0]!.firstWhere((element) => element.contains(index));
    }
  }

  void goToPage(int index) {
    if (isDoublePageView) {
      for (var i = 0; i < pageMap[1]!.length; i++) {
        if (pageMap[1]![i].contains(index)) {
          currentPageIndex = i;
          return;
        }
      }
    }
    currentPageIndex = index;
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

  int getDirectionFromAction(PageAction pa) {
    if (pa == PageAction.next) {
      if (currentPageIndex == pageMap[isDoublePageView ? 1 : 0]!.length - 1) {
        return 0;
      }
      return 1;
    }

    if (pa == PageAction.previous) {
      if (currentPageIndex == 0) {
        return 0;
      }
      return -1;
    }

    return 0;
  }

  String? checkBookBoundaries(PageAction pa) {
    if (openBook == null) {
      return null;
    }

    String? nextBook;

    if (pa == PageAction.next) {
      nextBook = nextBookPath;
    }
    if (pa == PageAction.previous) {
      nextBook = prevBookPath;
    }

    return nextBook;
  }

  void pageAction(PageAction pa) {
    final direction = getDirectionFromAction(pa);

    if (direction == 0) {
      final nextBook = checkBookBoundaries(pa);
      if (nextBook != null) {
        openBook!('/reader',
            {"id": 0, "path": nextBook, "initialPage": 0, "libraryId": 0});

        return;
      }
    }

    currentPageIndex = currentPageIndex + (direction);
    EasyThrottle.throttle('reader', const Duration(seconds: 1), () async {
      await DatabaseMangaHelpers.setCurrentlyReading(
          book.path, getCurrentPages().first);
    });
  }

  List<int> getCurrentPages() {
    if (pages.isEmpty) {
      return [];
    }
    return pageMap[isDoublePageView ? 1 : 0]![currentPageIndex];
  }

  void loadSettings(Settings settings) {
    final rtlSetting = settings.getByName('RTL');
    final doublePageSetting = settings.getByName('doublePage');
    isRightToLeftMode = rtlSetting.value;
    isDoublePageView = doublePageSetting.value;
  }
}
