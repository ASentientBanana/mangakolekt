import 'dart:io';

import 'package:mangakolekt/ffi/ffi_handler.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/constants.dart';
import 'package:image/image.dart' as dart_img;

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['zip', 'cbz'];

  @override
  Future<List<String>> unpackCovers(String pathToDir) async {
    final dir = Directory(p.join(pathToDir, libFolderName));
    final coversDir =
        Directory(p.join(pathToDir, libFolderName, libFolderCoverFolderName));
    // // Create expected dirs
    await dir.create();
    await coversDir.create();

    List<String> books;

    if (Platform.isLinux || Platform.isWindows) {
      final out = p.join(pathToDir, libFolderName, libFolderCoverFolderName);
      final dirContents = Directory(pathToDir);
      if (!await dirContents.exists()) return [];
      final targetFiles = await dirContents
          .list()
          .where(
              (element) => p.split(element.path).last.split('.').last == 'cbz')
          .map((event) => event.path)
          .toList();
      print(targetFiles);
      final output = await ffiUnzipCovers(targetFiles, pathToDir, out);
      return output;
    } else {
      books = await getBooksV2(pathToDir);
    }
    return books;
  }

  @override
  Future<Book?> unpack(String pathToBook, String dest) async {
    List<PageEntry> pages = [];
    final bookName = p.split(pathToBook).last;
    final success = await ffiUnzipSingleBook(pathToBook, dest);
    if (!success) {
      return null;
    }
    final dir = Directory(dest);
    if (!(await dir.exists())) return null;
    final dirFiles = await dir.list().where((event) {
      return supportedImageTypes.contains(event.path.split('.').last);
    }).toList();
    final fileCount = dirFiles.length;
    for (var e in dirFiles) {
      final file = File(e.path);
      if (!(await file.exists())) continue;
      pages.add(
        PageEntry(
          name: p.split(e.path).last,
          image: Image.file(file),
        ),
      );
    }
    if (pages.isEmpty) {
      return null;
    }
    return Book(
      pages: sortCoversPagesNumeric(pages),
      pageNumber: fileCount,
      name: bookName,
      path: p.dirname(pathToBook),
    );
  }

  @override
  bool checkType(String type) {
    return fileTypes.contains(type);
  }
}
