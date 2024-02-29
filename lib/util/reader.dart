import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:path/path.dart' as p;
import 'package:collection/collection.dart';

Future<Book?> getBook(BuildContext context, String bookPath, int? id) async {
  final dest = await getCurrentDirPath();
  Book? book;
  imageCache.clear();

  if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
    try {
      final params = [bookPath.split('.').last, bookPath, dest, id.toString()];
      book = await compute(ArchiveController.unpack, params);
      print("Got book");
      print(book?.pages[0]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );
    }
  } else {
    book = await getBookFromArchive(bookPath);
  }
  return book;
}

Future<Map<String, String>> checkForNextBook(String path) async {
  //get dir path
  final containingDirPath = p.dirname(path);

  // scan dir for files

  final dir = Directory(containingDirPath);

  final Map<String, String> map = {};

  // check if dir exists
  if (!(await dir.exists())) {
    return map;
  }
  // Get contents
  final contentsList = await dir.list().toList();
  final List<String> files = [];

  //Grab only the files
  for (var i = 0; i < contentsList.length; i++) {
    if ((await contentsList[i].stat()).type == FileSystemEntityType.file) {
      files.add(contentsList[i].path);
    }
  }
  //sort files numerically
  files.sort(compareNatural);

  //Find index of the file
  final fileIndex = files.indexOf(path);
  //Get next file path from list
  if (fileIndex + 1 < files.length) {
    map['next'] = files[fileIndex + 1];
  }
  // print("Previous book: ${files[fileIndex - 1]}");
  if (fileIndex - 1 >= 0) {
    map['prev'] = files[fileIndex - 1];
  }

  return map;
}
