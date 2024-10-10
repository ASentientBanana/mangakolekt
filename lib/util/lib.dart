import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
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

  //loop elements and null existing and mark entries for deletion
  for (var dbElement in []) {
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
