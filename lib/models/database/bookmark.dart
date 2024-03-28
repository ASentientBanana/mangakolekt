import 'package:mangakolekt/util/util.dart';

class Bookmark {
  final int page;
  final int date;
  final String book;
  const Bookmark({required this.page, required this.book, required this.date});
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
        ["id", "name", "page", "path", "created_at"],
      );
      if (!isValid) {
        continue;
      }

      if (map[element['id']] == null) {
        map[element['id']] = {
          "id": element["id"],
          "name": element["name"],
          "bookmarks": [],
          "path": element["path"],
        };
      }

      map[element["id"]]['bookmarks'].add(
        Bookmark(
            page: element["page"],
            book: element["path"],
            date: element["created_at"]),
      );
    }

    data = map.entries
        .map(
          (e) {
            return BookmarksData(
              path: e.value["path"],
              //REFACTOR:book
              //Very bad, compiler, temp solution for the compiler
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
