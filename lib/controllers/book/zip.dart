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

class BookController extends BaseBookController {
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
    await ffiUnzipSingleBook(pathToBook, dest);
    final dir = Directory(dest);
    if (!(await dir.exists())) return null;
    final dirFiles = await dir.list().where((event) {
      return supportedImageTypes.contains(event.path.split('.').last);
    }).toList();
    final fileCount = dirFiles.length;
    for (var e in dirFiles) {
      final name = p.split(e.path).last;
      final file = File(e.path);
      // print("Size: ${imageData.width}x${imageData.height}");
      if (!(await file.exists())) continue;
      // final img = Image.file(file);
      final img = Image.file(file);
      pages.add(PageEntry(name: name, image: img).setIsDouble(false));
      // final imageData = dart_img.decodeImage(await file.readAsBytes());

      // if (imageData != null) {
      //   final img = Image.memory(imageData.buffer.asUint8List());

      //   pages.add(PageEntry(name: name, image: img)
      //       .setIsDouble(imageData.width > imageData.height));
      // } else {
      //   final img = Image.file(file);
      //   pages.add(PageEntry(name: name, image: img).setIsDouble(false));
      // }
    }
    final b = Book(
        pages: sortCoversPagesNumeric(pages),
        pageNumber: fileCount,
        name: bookName);
    return b;
  }

  @override
  bool checkType(String type) {
    return fileTypes.contains(type);
  }
}
