import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/types/zip.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart' as p;

abstract class BaseBookController {
  bool checkType(String type);
  Future<void> unpack(String pathToBook, String dest);
  Future<List<String>> unpackCovers(String pathToDir,
      {required List<String> files, required String out});
}

class Runner {
  final String type;
  final BaseBookController controller;
  final List<String> files;
  Runner({required this.controller, required this.files, required this.type});
  @override
  operator ==(other) => other is Runner && other.type == type;

  @override
  int get hashCode => Object.hash(type, type);
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
    final String id = args[3];
    final controller = ArchiveController.getTypeController(type);
    if (controller == null) {
      return null;
    }
    //unzip to the current dir.
    await controller.unpack(pathToBook, dest);
    //load book here from current dir
    final book = await loadBook(dest, pathToBook, id);
    return book;
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

  static Future<Book?> loadBook(
      String target, String pathToBook, String? id) async {
    // List<String> _pages = await compute((message) async {
    // return await _loadPagesRecursive(message);
    // }, target);
    print("`Looking in`: $target");
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
      pages.add(
          PageEntry(name: p.split(_pages[i]).last, image: Image.file(file)));
    }
    return Book(
        id: id != null ? int.tryParse(id) : null,
        name: p.split(pathToBook).last,
        pageNumber: pages.length,
        pages: pages,
        path: pathToBook);
  }

  static Future<List<String>?> unpackCovers(
      String pathToDir, List<String>? files) async {
    //create dirs
    final coversDir =
        Directory(p.join(pathToDir, libFolderName, libFolderCoverFolderName));
    // // Create expected dirs
    await coversDir.create(recursive: true);

    final out = p.join(pathToDir, libFolderName, libFolderCoverFolderName);

    final types = <String, Runner>{};
    final dir = Directory(pathToDir);
    if (!await dir.exists()) {
      return [];
    }
    // get a list of files
    final _files = files ?? (await getFilesFromDir(dir));

    //Build map of types
    for (var element in _files) {
      final type = p.extension(element).substring(1);

      if (types[type] == null) {
        final controller = getTypeController(type);
        if (controller == null) {
          continue;
        }
        types[type] =
            Runner(controller: controller, files: [element], type: type);
        continue;
      }
      //if the types is in the types map
      types[type]?.files.add(element);
    }
    //Create covers list and add all the covers
    final List<String> allCovers = [];
    for (var key in types.keys) {
      if (types[key] == null) {
        continue;
      }
      final covers = await types[key]
          ?.controller
          .unpackCovers(pathToDir, files: types[key]?.files ?? [], out: out);
      if (covers != null) {
        allCovers.addAll(covers);
      }
    }
    return allCovers;
  }
}
