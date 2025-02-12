import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/types/zip.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart' as p;

abstract class BaseBookController {
  List<String> fileTypes = [];
  bool checkType(String type);
  Future<Book?> unpack(String pathToBook, String dest);
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
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
  static List<BaseBookController> controllers = [
    ZipBookController(),
  ];

  static List<String> supportedFormats() {
    final List<String> types = [];
    final len = ArchiveController.controllers.length;
    for (var i = 0; i < len; i++) {
      types.addAll(ArchiveController.controllers[i].fileTypes);
    }
    return types;
  }

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
    //TODO: Use id its just hanging here.
    final String id = args[3];
    final controller = ArchiveController.getTypeController(type);
    if (controller == null) {
      throw Error.safeToString('Unsupported file type selected.');
    }
    return await controller.unpack(pathToBook, dest);
  }

  static Future<List<String>> loadPagesRecursive(String dirPath) async {
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
      final res = await loadPagesRecursive(dirs[i]);
      dContents.addAll(res);
    }
    return dContents;
  }

  static Future<Book?> loadBook(
      String target, String pathToBook, String? id) async {
    // List<String> _pages = await compute((message) async {
    // return await _loadPagesRecursive(message);
    // }, target);
    final pages0 = await loadPagesRecursive(target);
    pages0.sort(compareNatural);
    // // _pages = sortNumeric(_pages);

    final List<PageEntry> pages = [];

    for (var i = 0; i < pages0.length; i++) {
      if (i < 0) {
        continue;
      }
      final file = File(pages0[i]);
      if (!(await file.exists())) {
        continue;
      }
      pages.add(PageEntry(
          name: p.split(pages0[i]).last,
          image: Image.file(file),
          isDouble: false));
    }
    return Book(
        id: id != null ? int.tryParse(id) : null,
        name: p.split(pathToBook).last,
        pageNumber: pages.length,
        pages: pages,
        path: pathToBook);
  }

  static Future<List<FFICoverOutputResult>?> unpackCovers(
      String pathToDir, String out) async {
    //create dirs
    final types = <String, Runner>{};
    final dir = Directory(pathToDir);
    if (!await dir.exists()) {
      return [];
    }

    // get a list of files
    final files = (await getFilesFromDir(dir));
    //Build map of types
    for (var element in files) {
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
    final List<FFICoverOutputResult> allCovers = [];
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
