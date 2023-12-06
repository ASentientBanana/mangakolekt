import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/types/zip.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

abstract class BaseBookController {
  bool checkType(String type);
  Future<void> unpack(String pathToBook, String dest);
  Future<List<String>> unpackCovers(String pathToDir);
}

class ArchiveController {
  // Add controllers for the file types
  static List<BaseBookController> controllers = [ZipBookController()];

  static BaseBookController? getTypeController(String type) {
    for (var controller in ArchiveController.controllers) {
      if (controller.checkType(type)) {
        return controller;
      }
    }
    return null;
  }

  static FutureOr<Book?> unpack(List<String> args) async {
    //file type (eg: zip)
    final type = args[0];
    final pathToBook = args[1];
    final dest = args[2];
    final controller = ArchiveController.getTypeController(type);
    if (controller == null) {
      return null;
    }
    controller.unpack(pathToBook, dest);
    //load book here
    return await loadBook(dest, pathToBook);
  }

  static void sortMe(List<String> files) {}

  static Future<List<String>> _loadPagesRecursive(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      return [];
    }
    List<String> files = [];
    List<String> dirs = [];
    final contents = await dir.list().toList();
    final len = contents.length;
    for (var i = 0; i < len; i++) {
      final element = contents[i];
      final type = (await element.stat()).type;

      if (type == FileSystemEntityType.file) {
        files.add(element.path);
        continue;
      }
      if (type == FileSystemEntityType.directory) {
        dirs.add(element.path);
        continue;
      }
    }
    dirs = sortNumeric(dirs);
    files = sortNumeric(files);
    // files = files.sorted(compareIntPrefixes);
    // files.sort(compareNatural);

    // Display sorted files

    final List<String> dContents = [];
    dContents.addAll(files);

    for (var i = 0; i < dirs.length; i++) {
      final res = await _loadPagesRecursive(dirs[i]);
      dContents.addAll(res);
    }
    return dContents;
  }

  static Future<Book?> loadBook(String target, String pathToBook) async {
    final _pages = await _loadPagesRecursive(target);

    final List<PageEntry> pages = [];

    for (var i = 0; i < _pages.length; i++) {
      final file = File(_pages[i]);
      if (!await file.exists()) {
        continue;
      }
      pages
          .add(PageEntry(name: split(_pages[i]).last, image: Image.file(file)));
    }
    print("Loaded book");
    return Book(
        name: split(pathToBook).last,
        pageNumber: pages.length,
        pages: pages,
        path: pathToBook);
  }

  static Future<Future<List<String>> Function(String)?> unpackCovers(
    String pathToDir,
  ) async {
    final dir = Directory(pathToDir);
    final dirList = (await dir.list().toList());

    final controller =
        ArchiveController.getTypeController(dirList.last.path.split('.').last);
    if (controller == null) {
      return null;
    }
    return controller.unpackCovers;
  }

//   List<String> sortFilesInDirectory(Directory directory) {
//     List<FileSystemEntity> files = directory.listSync();

//   if (directory.existsSync())

//   } else {
//     print('Directory not found.');
//   }
// }
}
