import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:path/path.dart' as p;

class RefreshResults {
  List<String> toDelete = [];
  List<String> toAdd = [];
}

Future<RefreshResults?> getRefreshLibPaths(BookCover item) async {
  final Map<String, int> _covers = {};
  final bookDir = Directory(item.path);

  if (!await bookDir.exists()) {
    return null;
  }
  //check what needs to be deleted and what should be added
  //file list is the source of truth
  final List<String> _fileList = await getFilesFromDir(bookDir);

  // files -> Map to make the checking faster
  // 1 - to add, -1 - to delete, 0 - leave alone
  for (var file in _fileList) {
    // print("Looking at entry: $file");
    _covers[file] = 1;
  }
  // generate a list of paths from the database
  final List<String> databaseList =
      (await DatabaseMangaHelpers.getCoversFromMangaMap(item.id))
          .map((e) => e.bookPath)
          .toList();

  //loop elements and null existing and mark entries for deletion
  for (var dbElement in databaseList) {
    if (_covers[dbElement] != null) {
      _covers[dbElement] = 0;
      continue;
    }
    _covers[dbElement] = -1;
  }

  //loopMap and sort
  final refresh = RefreshResults();

  _covers.forEach((key, value) {
    switch (value) {
      case -1:
        refresh.toDelete.add(key);
        break;
      case 1:
        refresh.toAdd.add(key);
        break;
      default:
    }
  });

  return refresh;
}

Future<List<BookCover>?> refreshLib({required BookCover item}) async {
  final RefreshResults? refreshItems = await getRefreshLibPaths(item);
  if (refreshItems == null) {
    return null;
  }

  await DatabaseMangaHelpers.batchRemoveLibManga(refreshItems.toDelete);
  //fs work
  if (refreshItems.toAdd.isNotEmpty) {
    final covers = await compute(
        (message) => ArchiveController.unpackCovers(
            message[0] as String, message[1] as List<String>),
        [item.path, refreshItems.toAdd]);
    if (covers == null) {
      return null;
    }
    await DatabaseMangaHelpers.batchAddLibManga(covers, item.id);
  }
  final mangaList = await DatabaseMangaHelpers.getManga();

  return mangaList;
}

Future<bool> deleteLib(String path) async {
  //template name;path;bookPath
  //check if app mapFile and lib mapFile exist;

  // final libDir = Directory("$path/$libFolderName");
  final libDir = Directory(p.join(path, libFolderName));
  if (await libDir.exists()) {
    await libDir.delete(recursive: true);
  }
  return true;
}

//TODO: implement a cleanup func for the current folder
Future<void> cleanupCoversFolder(
  List<String> db,
) async {}
