import 'dart:io';

import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';

class RefreshResults {
  List<String> toDelete = [];
  List<String> toAdd = [];
}

Future<RefreshResults?> getRefreshLibPaths(BookCover item) async {
  final Map<String, int> covers = {};
  final bookDir = Directory(item.path);

  if (!await bookDir.exists()) {
    return null;
  }
  //check what needs to be deleted and what should be added
  //file list is the source of truth
  final List<String> fileList = await getFilesFromDir(bookDir);

  // files -> Map to make the checking faster
  // 1 - to add, -1 - to delete, 0 - leave alone
  for (var file in fileList) {
    // print("Looking at entry: $file");
    covers[file] = 1;
  }

  //loop elements and null existing and mark entries for deletion
  for (var dbElement in []) {
    if (covers[dbElement] != null) {
      covers[dbElement] = 0;
      continue;
    }
    covers[dbElement] = -1;
  }

  //loopMap and sort
  final refresh = RefreshResults();

  covers.forEach((key, value) {
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
