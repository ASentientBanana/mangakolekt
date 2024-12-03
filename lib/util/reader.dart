import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:path/path.dart' as p;
import 'package:collection/collection.dart';

Alignment setAliment(bool isDouble, int index) {
  if (!isDouble) {
    return Alignment.center;
  }
  // This is to keep the images together when in double page view
  return index == 0 ? Alignment.centerRight : Alignment.centerLeft;
}

Future<Book?> getBook(BuildContext context, String bookPath, int? id) async {
  final dest = await getCurrentDirPath();
  Book? book;
  imageCache.clear();

  if (!(Platform.isLinux || Platform.isWindows || Platform.isAndroid)) {
    return null;
  }
  try {
    final params = [bookPath.split('.').last, bookPath, dest, id.toString()];
    book = await ArchiveController.unpack(params);
    if(id != null && book?.id == null){
      book?.id = id;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
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
