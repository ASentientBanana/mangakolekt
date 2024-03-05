import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/models/library.dart';
import 'package:mangakolekt/util/database/database_core.dart';
import 'package:mangakolekt/util/database/database_table.dart';
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
      {required List<String> books,
      required String name,
      required String libraryPath}) async {
    final db = await DatabaseCore.openDB();

    final id = await db
        .insert(DatabaseTables.Library, {"name": name, "path": libraryPath});

    // create batch
    final batch = db.batch();
    //loop and call insert on batch

    for (var mapString in books) {
      final mListItem = mapString.split(';');
      batch.insert(
        DatabaseTables.Book,
        {
          'name': mListItem[0],
          "cover": mListItem[1],
          "path": mListItem[2],
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

  static Future<Bookmarks> getBookmarks({String? path}) async {
    try {
      if (path == null) {
        final db = await DatabaseCore.openDB();
        final results = await db.rawQuery(
            "SELECT * FROM ${DatabaseTables.Bookmarks} LEFT JOIN ${DatabaseTables.Book} ON ${DatabaseTables.Book}.id = ${DatabaseTables.Bookmarks}.book;");

        print(results);
        db.close();
        return Bookmarks.fromMaps(results);
      }

      final results = await DatabaseCore.queryDB(
          table: DatabaseTables.Bookmarks, where: "path=?", args: [path]);
      return Bookmarks.fromMaps(results);
    } catch (e) {
      print(e);
      return Bookmarks.Empty();
    }
  }

  static Future<void> addBookmark(
      {required int book, required int page, required String path}) async {
    final db = await DatabaseCore.openDB();
    await db.insert(DatabaseTables.Bookmarks, {
      "book": book,
      "page": page,
      "path": path,
      "created_at": DateTime.now().millisecondsSinceEpoch
    });
    await db.close();
  }

  static Future<void> removeBookmark(
      {required int manga, required int page}) async {
    await DatabaseCore.deleteFromDB(
        table: DatabaseTables.Bookmarks,
        where: 'manga = ? AND page = ?',
        args: [manga, page]);
  }
}
