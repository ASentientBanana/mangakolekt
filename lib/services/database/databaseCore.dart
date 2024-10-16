import 'dart:io';

import 'package:mangakolekt/models/global.dart';
import 'package:mangakolekt/services/database/table_definitions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class DatabaseCore {
  // static List<DatabaseTable> tables = databaseTableDefinitions;

  static Future<void> initDatabase() async {
    sqfliteFfiInit();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocumentDir.path, mangaDirName, databaseName);
    final fDb = File(dbPath);

    if (!await fDb.exists()) {
      await fDb.create();
    }

    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(dbPath);

    for (var table in databaseTableDefinitions) {
      await db.execute(table.build());
    }
    await db.close();
  }

  static Future<Database> openDB() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocumentDir.path, mangaDirName, databaseName);
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(dbPath);

    return db;
  }

  static Future<List<Map<String, Object?>>?> writeToDB(
      {required String table,
      required Map<String, Object?> data,
      bool returnTable = false}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocumentDir.path, mangaDirName, databaseName);
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(dbPath);

    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);

    dynamic res;
    if (returnTable) {
      res = await db.query(table);
    }
    await db.close();
    return res;
  }

  static Future<List<Map<String, Object?>>> deleteFromDB(
      {required String table,
      String? where,
      List<dynamic>? args,
      bool returnTable = false}) async {
    final db = await DatabaseCore.openDB();

    await db.delete(table, where: where, whereArgs: args);

    if (!returnTable) {
      return [];
    }

    final res = db.query(table);
    await db.close();
    return res;
  }

  static Future<List<Map<String, Object?>>> readFromDB(
      {required String query}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocumentDir.path, mangaDirName, databaseName);
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(dbPath);

    var result = await db.query(query);

    await db.close();
    return result;
  }

  static Future<List<Map<String, Object?>>> queryDB(
      {required String table,
      String? where,
      List<Object>? args,
      String? orderBy}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocumentDir.path, mangaDirName, databaseName);
    var databaseFactory = databaseFactoryFfi;

    var db = await databaseFactory.openDatabase(dbPath);

    var result =
        await db.query(table, where: where, whereArgs: args, orderBy: orderBy);

    await db.close();
    return result;
  }

  static Future<List<Map<String, Object?>>?> removeFromDB(
      {required String table,
      required String path,
      bool returnTable = false}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDocumentDir.path, mangaDirName, databaseName);
    var databaseFactory = databaseFactoryFfi;
    var db = await databaseFactory.openDatabase(dbPath);

    final count = await db.delete(table, where: "path = ?", whereArgs: [path]);

    if (!(count > 0 || returnTable)) {
      db.close();
      return null;
    }
    final res = await db.query(table);
    db.close();
    return res;
  }
}
