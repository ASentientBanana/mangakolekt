

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
    for (var element in data) {
      final foundBook = path == element.path;
      if (!foundBook) {
        continue;
      }
      for (var i = 0; i < element.bookmarks.length; i++) {
        final page0 = element.bookmarks[i].page;
        if (page0 == page) {
          containsBookmark = true;
          continue;
        }
      }
    }
    return containsBookmark;
  }

  Bookmarks.fromMaps(List<Map<String, dynamic>> maps) {
    // Reformat the data to look like
    /*
      [
        {id, name, bookmarks:[{ page, date, book }], }
      ]
    */

    final Map<int, BookmarksData> map = {};
    data = [];
    for (var element in maps) {
      try {
        final bm = Bookmark(
            page: element['page'],
            book: element['book'].toString(),
            date: element['createdAt'] ?? -1,
            id: element['id']);
        final libraryId = element['library'];
        if (map[libraryId] == null) {
          map[libraryId] = BookmarksData(
              path: element['path'],
              bookmarks: [bm],
              id: element['library'],
              name: element['name'] ?? 'unknown');
        } else {
          map[libraryId]?.bookmarks.add(bm);
        }
      } catch (e) {
        print(e);
      }
    }
    for (var element in map.keys) {
      if (map[element] != null) {
        data.add(map[element]!);
      }
    }
  }
}
