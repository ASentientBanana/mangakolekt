import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/util/database/database_core.dart';
import 'package:mangakolekt/util/database/database_table.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseMangaHelpers {
  static getAllManga() {
    DatabaseCore.readFromDB(
        query: "Select * FROM TABLE ${DatabaseTables.Manga}");
  }

  static Future<List<BookCover>> getCoversFromMangaMap(int manga_id) async {
    final res = await DatabaseCore.queryDB(
        table: DatabaseTables.MangaMap,
        where: "manga_id = ?",
        args: [manga_id],
        orderBy: "name");

    return sortCoversNumeric(List.generate(
        res.length,
        (index) => BookCover(
            name: res[index]['name'] as String,
            path: res[index]['path'] as String,
            bookPath: res[index]['bookPath'] as String,
            id: res[index]['manga_id'] as int)));
  }

  static Future<void> deleteManga(int id) async {
    await DatabaseCore.deleteFromDB(
        table: DatabaseTables.Manga, where: 'id = ?', args: [id]);
    await DatabaseCore.deleteFromDB(
        table: DatabaseTables.MangaMap, where: 'manga_id = ?', args: [id]);
  }

  static Future<void> addMangaMapping(List<String> mapList, int id) async {
    final db = await DatabaseCore.openDB();
    for (var mapString in mapList) {
      final mList = mapString.split(';');
      await db.insert(
          DatabaseTables.MangaMap,
          {
            'name': mList[0],
            'path': mList[1],
            'bookPath': mList[2],
            'manga_id': id
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await db.close();
  }

  static Future<void> updateMangaMapping(List<String> mapList, int id) async {
    final db = await DatabaseCore.openDB();
    for (var mapString in mapList) {
      final mList = mapString.split(';');
      await db.update(
          DatabaseTables.MangaMap,
          {
            'name': mList[0],
            'path': mList[1],
            'bookPath': mList[2],
            'manga_id': id
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await db.close();
  }

  static Future<List<BookCover>?> getManga() async {
    final res = await DatabaseCore.queryDB(table: DatabaseTables.Manga);

    return List.generate(
      res.length,
      (index) => BookCover(
          id: res[index]["id"] as int,
          name: res[index]["name"] as String,
          path: res[index]["path"] as String,
          bookPath: ""),
    );
  }

  static Future<List<BookCover>?> addManga(
      {required String name,
      required String path,
      bool returnManga = false}) async {
    await DatabaseCore.writeToDB(
        table: DatabaseTables.Manga, data: {"name": name, "path": path});
    if (!returnManga) {
      return null;
    }
    final res = await DatabaseCore.queryDB(table: DatabaseTables.Manga);
    if (res.isEmpty) {
      return null;
    }

    return List.generate(
      res.length,
      (index) => BookCover(
          id: res[index]["id"] as int,
          name: res[index]["name"] as String,
          path: res[index]["path"] as String,
          bookPath: ""),
    );
  }

  static Future<void> setCurrentManga(String manga, int page) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final db = await DatabaseCore.openDB();
      //check for results
      final qRes = await db
          .query(DatabaseTables.Reader, where: 'manga = ?', whereArgs: [manga]);
      if (qRes.isEmpty) {
        await DatabaseCore.writeToDB(table: DatabaseTables.Reader, data: {
          "manga": manga,
          "currentPage": page,
          "doublePageView": 0,
          'updated_at': now
        });
        return;
      }
      await db.update(DatabaseTables.Reader, {
        "manga": manga,
        "currentPage": page,
        "doublePageView": 0,
        'updated_at': now
      });
    } catch (e) {
      return;
    }
    // await DatabaseCore.writeToDB(table: DatabaseTables.Reader, data: {});
  }

  static Future<void> addBookmark(
      {required int manga, required int page, required String book}) async {
    final db = await DatabaseCore.openDB();
    await db.insert(DatabaseTables.Bookmarks, {
      "manga": manga,
      "page": page,
      "book": book,
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

  static Future<Bookmarks> getBookmarks() async {
    final db = await DatabaseCore.openDB();
    // grab all of the data
    final results = await db.rawQuery(
        "SELECT * FROM ${DatabaseTables.Bookmarks} LEFT JOIN ${DatabaseTables.Manga} ON ${DatabaseTables.Manga}.id = ${DatabaseTables.Bookmarks}.manga;");
    // close connection
    await db.close();
    return Bookmarks.fromMaps(results);
  }

  static Future<List<int>> getBookmarksForManga(int manga) async {
    final qRES = await DatabaseCore.queryDB(
        table: DatabaseTables.Bookmarks, where: "manga = ?", args: [manga]);
    return qRES.map((e) => e['page'] as int).toList();
  }

  static Future<void> batchRemoveLibManga(List<String> manga) async {
    if (manga.isEmpty) {
      return;
    }
    //Construct args string for raw sql query
    final args = '(${manga.map((e) => '"$e"').join(",")})';
    final db = await DatabaseCore.openDB();
    await db.rawQuery("DELETE FROM MangaMap WHERE bookPath IN $args");
    db.close();
  }

  static Future<void> batchAddLibManga(List<String> manga, int id) async {
    if (manga.isEmpty) {
      return;
    }

    final db = await DatabaseCore.openDB();
    // create batch
    final batch = db.batch();
    //loop and call insert on batch

    for (var mapString in manga) {
      final mList = mapString.split(';');
      batch.insert(
        DatabaseTables.MangaMap,
        {
          'name': mList[0],
          'path': mList[1],
          'bookPath': mList[2],
          'manga_id': id
        },
      );
    }

    //commit to db
    await batch.commit();
    db.close();
  }

  Future<void> getLatestManga() async {
    final db = await DatabaseCore.openDB();
    // "SELECT * FROM ${DatabaseTables.Bookmarks} LEFT JOIN ${DatabaseTables.Manga} ON ${DatabaseTables.Manga}.id = ${DatabaseTables.Bookmarks}.manga;");

    final results = db.query(DatabaseTables.Reader,
        where: 'updated_at IS NOT NULL ORDER BY updated_at DESC');
    print(results);
  }
}
