import 'package:mangakolekt/util/util.dart';

class Bookmark {
  final int page;
  final int date;
  final String book;
  final int id;
  const Bookmark(
      {required this.page,
      required this.book,
      required this.date,
      required this.id});
}

class BookmarksData {
  late final String name;
  late final String path;
  late final int id;
  late final List<Bookmark> bookmarks;

  BookmarksData(
      {required this.path,
      required this.bookmarks,
      required this.id,
      required this.name});

  BookmarksData.Empty() {
    name = '';
    path = '';
    id = -1;
    bookmarks = [];
  }
}

class Bookmarks {
  late final List<BookmarksData> data;

  Bookmarks.Empty() {
    data = [];
  }

  bool containsBookmark(String path, int page) {
    bool containsBookmark = false;
    data.forEach((element) {
      final foundBook = path == element.path;
      if (!foundBook) {
        return;
      }
      for (var i = 0; i < element.bookmarks.length; i++) {
        final _page = element.bookmarks[i].page;
        if (_page == page) {
          containsBookmark = true;
          return;
        }
      }
    });
    return containsBookmark;
  }

  Bookmarks.fromMaps(List<Map<String, dynamic>> _maps) {
    // Reformat the data to look like
    /*
      [
        {id, name, bookmarks:[{ page, date, book }], }
      ]
    */
    final map = {};
    for (var element in _maps) {
      final isValid = validateMap(
        element,
        ["id", "name", "page", "book_path", "created_at", "library"],
      );
      if (!isValid) {
        continue;
      }
      if (map[element['library']] == null) {
        map[element['library']] = {
          "id": element["library"],
          "name": element["name"],
          "bookmarks": [],
          "path": element["path"],
        };
      }
      map[element["library"]]['bookmarks'].add(
        Bookmark(
            id: element['book'],
            page: element["page"],
            book: element["book_path"],
            date: element["created_at"]),
      );
    }

    data = map.entries
        .map(
          (e) {
            return BookmarksData(
              path: e.value["path"],
              bookmarks: (e.value["bookmarks"] as List<dynamic>)
                  .map((e) => e as Bookmark)
                  .toList(),
              id: e.value["id"],
              name: e.value["name"],
            );
          },
        )
        // id is set to -1 on invalid elements
        .where((element) => element.id != -1)
        .toList();
  }
}
