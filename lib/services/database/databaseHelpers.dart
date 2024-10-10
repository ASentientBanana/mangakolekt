import 'dart:async';

import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/services/database/databaseCore.dart';
import 'package:mangakolekt/services/database/databaseTable.dart';
import 'package:mangakolekt/util/util.dart';

class DatabaseMangaHelpers {
  static Future<List<LibraryElement>> getLibraries({String? id}) async {
    if (id != null) {
      DatabaseCore.readFromDB(
          query: "Select * FROM TABLE ${DatabaseTables.Book}");
    }
    return [];
  }

  static getAllManga() {
    DatabaseCore.readFromDB(
        query: "Select * FROM TABLE ${DatabaseTables.Book}");
  }

  static Future<List<LibraryElement>> getAllBooksFromLibrary() async {
    final Map<int, LibraryElement> libraryMap = {};
    final db = await DatabaseCore.openDB();
    final res = await db.rawQuery(
        "SELECT ${DatabaseTables.Book}.library as id, ${DatabaseTables.Book}.id as book_id, ${DatabaseTables.Library}.path as library_path , ${DatabaseTables.Book}.path as path, cover, ${DatabaseTables.Book}.name as book_name, ${DatabaseTables.Library}.name as library_name FROM ${DatabaseTables.Book} RIGHT JOIN ${DatabaseTables.Library} ON ${DatabaseTables.Library}.id = ${DatabaseTables.Book}.library;");

    //Construct lib element map
    for (var i = 0; i < res.length; i++) {
      final element = res[i];
      //check for id
      if (element['id'] == null) {
        continue;
      }

      if (libraryMap[element['id']] == null) {
        libraryMap[element['id'] as int] = LibraryElement(
            id: element['id'] as int,
            path: element['library_path'] as String,
            name: element['library_name'] as String);
      }

      //validate map to see if all fields are present
      final isValid = validateMap(element, [
        "id",
        "book_id",
        "path",
        "cover",
        "book_name",
        "library_name",
      ]);

      if (!isValid) {
        continue;
      }

      libraryMap[element['id']]!.books.add(
            BookCover(
                id: element["book_id"] as int,
                name: element["book_name"] as String,
                path: element["cover"] as String,
                bookPath: element["path"] as String),
          );
    }
    return libraryMap.entries.map((e) => e.value).toList();
  }

  static Future<int> addLibrary(
      {required List<FFICoverOutputResult> books,
      required String name,
      required String libraryPath}) async {
    final db = await DatabaseCore.openDB();

    final id = await db
        .insert(DatabaseTables.Library, {"name": name, "path": libraryPath});

    // create batch
    final batch = db.batch();
    //loop and call insert on batch

    for (var cover in books) {
      batch.insert(
        DatabaseTables.Book,
        {
          'name': cover.archiveName,
          "cover": cover.destinationPath,
          "path": cover.directoryFile,
          "library": id
        },
      );
    }
    //commit to db
    await batch.commit();
    // final res = await db.query(DatabaseTables.Book);

    await db.close();
    return id;
  }

  static Future<List<String>> deleteLibrary(int id) async {
    List<String> deleted = [];
    final db = await DatabaseCore.openDB();
    final batch = db.batch();
    batch.query(DatabaseTables.Book,
        columns: ["cover"], where: 'library=?', whereArgs: [id]);
    batch.delete(DatabaseTables.Library, where: "id=?", whereArgs: [id]);
    batch.delete(DatabaseTables.Book, where: 'library=?', whereArgs: [id]);
    final res = await batch.commit();

    //Its 0 because commit returns the results in the order called
    final paths = res[0] as List<dynamic>;
    for (var path in paths) {
      if (path['cover'] != null) {
        deleted.add(path['cover']!);
      }
    }

    db.close();
    return deleted;
  }

  static Future<void> setCurrentlyReading(String path, int page) async {
    try {
      // final now = DateTime.now().millisecondsSinceEpoch;
      final db = await DatabaseCore.openDB();

      await db.delete(DatabaseTables.Reader);

      await db.insert(DatabaseTables.Reader, {"path": path, "page": page});

      db.close();
    } catch (e) {
      return;
    }
  }

  // Bookmark
  static Future<List<int>> getBookmarkedPagesForBook(
      {String? path, int? book}) async {
    final db = await DatabaseCore.openDB();

    List<Map<String, dynamic>> results = [];

    if (book != null && book != -1) {
      results = await db.query(DatabaseTables.Bookmarks,
          where: 'book = ?', whereArgs: [book]);
    } else if (path != null) {
      results = await db.query(DatabaseTables.Bookmarks,
          where: 'path = ? AND book = ?', whereArgs: [path, -1]);
    }
    final List<int> pages = [];
    results.forEach((b) {
      if (b['page'] != Null) {
        pages.add(b['page']! as int);
      }
    });
    return pages;
  }

  // add a bookmark
  static Future<List<int>> bookmark(BookmarkEvent event) async {
    final db = await DatabaseCore.openDB();

    final results = await db.query(DatabaseTables.Bookmarks,
        where: 'path = ? AND book = ? AND page = ?',
        whereArgs: [event.path, event.book, event.page]);

    final isBookmarked = results.isNotEmpty;

    if (isBookmarked) {
      await db.delete(
        DatabaseTables.Bookmarks,
        where: 'path = ? AND book = ? AND page = ?',
        whereArgs: [event.path, event.book, event.page],
      );
    }

    if (!isBookmarked) {
      await db.insert(DatabaseTables.Bookmarks, event.toMap());
    }
    final queryResult = await db.query(DatabaseTables.Bookmarks,
        where: "book = ?", whereArgs: [event.book]);

    db.close();

    final List<int> pages = [];
    queryResult.forEach((b) {
      if (b['page'] != Null) {
        pages.add(b['page']! as int);
      }
    });
    return pages;
  }

  static Future<Bookmarks> getAllBookmarks() async {
    final db = await DatabaseCore.openDB();

    final sql =
        'SELECT ${DatabaseTables.Library}.name, ${DatabaseTables.Bookmarks}.* FROM ${DatabaseTables.Bookmarks} LEFT JOIN ${DatabaseTables.Library} ON ${DatabaseTables.Bookmarks}.library = ${DatabaseTables.Library}.id;';
    final queryResult = await db.rawQuery(sql);

    print(sql);

    if (queryResult.isEmpty) {
      db.close();
      return Bookmarks.Empty();
    }

    db.close();
    return Bookmarks.fromMaps(queryResult);
  }
}

class BookmarkEvent {
  int page;
  String path;
  int book;
  int library;
  BookmarkEvent(
      {required this.page,
      required this.path,
      this.book = -1,
      this.library = -1});

  Map<String, dynamic> toMap() {
    return {'page': page, 'path': path, 'book': book, 'library': library};
  }
}
