class Bookmark {
  final int page;
  final int date;
  final String book;
  const Bookmark({required this.page, required this.book, required this.date});
}

class BookmarksData {
  final String name;
  final String path;
  final int id;
  final List<Bookmark> bookmarks;
  const BookmarksData(
      {required this.path,
      required this.bookmarks,
      required this.id,
      required this.name});
}

class Bookmarks {
  Bookmarks.Empty() {
    data = [];
  }

  late final List<BookmarksData> data;
  Bookmarks.fromMaps(List<Map<String, dynamic>> d) {
    // TODO: Kinda ugly, should fix;
    // Reformat the data to look like
    /*
      [
        {id, name, bookmarks:{ page, date, book }, }
      ]
    */
    final map = {};

    for (var e in d) {
      final element = map[e['id'].toString()];
      if (element == null) {
        map[e["id"].toString()] = {
          "id": e["id"],
          "name": e["name"],
          "path": e["path"],
          "bookmarks": [
            Bookmark(
                page: e["page"], book: e["book"], date: e["created_at"] ?? 0)
          ]
        };
      } else {
        (map[e["id"].toString()]["bookmarks"] as List<Bookmark>).add(
            Bookmark(page: e["page"], book: e["book"], date: e["created_at"]));
      }
    }

    data = map.entries
        .map((e) => BookmarksData(
            bookmarks: e.value["bookmarks"] as List<Bookmark>,
            id: e.value["id"] ?? 0,
            path: e.value["path"] ?? 'No path found',
            name: e.value["name"] ?? 'Manga'))
        .toList();
  }
}
