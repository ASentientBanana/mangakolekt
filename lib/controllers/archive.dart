import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/types/zip.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart';
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
    //unzip to the current dir.
    await controller.unpack(pathToBook, dest);
    //load book here from current dir
    return await loadBook(dest, pathToBook);
    // return null;
  }

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
    final List<String> dContents = [];
    dContents.addAll(files);

    for (var i = 0; i < dirs.length; i++) {
      final res = await _loadPagesRecursive(dirs[i]);
      dContents.addAll(res);
    }
    return dContents;
  }

  static Future<Book?> loadBook(String target, String pathToBook) async {
    // List<String> _pages = await compute((message) async {
    // return await _loadPagesRecursive(message);
    // }, target);
    final _pages = await _loadPagesRecursive(target);
    _pages.sort(compareNatural);
    // // _pages = sortNumeric(_pages);

    final List<PageEntry> pages = [];

    for (var i = 0; i < _pages.length; i++) {
      if (i < 0) {
        continue;
      }
      final file = File(_pages[i]);
      if (!(await file.exists())) {
        continue;
      }
      pages
          .add(PageEntry(name: split(_pages[i]).last, image: Image.file(file)));
    }
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
}
