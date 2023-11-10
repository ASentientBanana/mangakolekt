import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/models/book.dart';
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
    // query: 'SELECT * FROM Manga WHERE name = "Holyland";');
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

  static Future<void> setCurrentManga(int id, int page) async {
    await DatabaseCore.writeToDB(
        table: DatabaseTables.Reader,
        data: {"currentPage": page, "manga": id, "doublePageView": 0});
    // await DatabaseCore.writeToDB(table: DatabaseTables.Reader, data: {});
  }
}
