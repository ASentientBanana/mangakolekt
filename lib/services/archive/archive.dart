import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/util/util.dart';
import "dart:io";
import 'package:mangakolekt_archive_lib/mangakolekt_archive_zip/mangakolekt_archive_book.dart';
import 'package:mangakolekt_archive_lib/models/ffi_book_output_result.dart'
    as mangaLibBook;
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';

Future<void> recreateDirectory(String directoryPath) async {
  final dir = Directory(directoryPath);
  await dir.delete(recursive: true);
  await dir.create();
}

List<List<String>> chunkify(List<String> files) {
  final List<List<String>> chunks = [];
  const numberOfChunks = 3;
  if (files.length < numberOfChunks) {
    return [files];
  }
  // [ 1,2,3,4,5].len /3 .round ->1.
  final chunkSize = (files.length / numberOfChunks).round();

  for (int i = 0; i < numberOfChunks; i++) {
    if (i == numberOfChunks - 1) {
      //non inclusive
      chunks.add(files.sublist(i * chunkSize, files.length));
      break;
    }
    chunks.add(files.sublist(i * chunkSize, (i * chunkSize) + chunkSize));
  }
  return chunks;
}

Future<List<FFICoverOutputResult>> unzipArchiveCoversDart(
    List<dynamic> props) async {
  List<String> files = props[0];
  String out = props[1];
  final res = _unzipArchiveCovers([files, out]);
  return res;
}

Future<List<FFICoverOutputResult>> _unzipArchiveCovers(
    List<dynamic> props) async {
  final List<String> files = props[0];
  final String out = props[1];
  final List<FFICoverOutputResult> response = [];

  for (var i = 0; i < files.length; i++) {
    final file = files[i];
    // final openedFile = File(file);
    final inputStream = InputFileStream(file);
    // final archiveFile = await openedFile.readAsBytes();
    // final archive = ZipDecoder().decodeBytes(await openedFile.readAsBytes());
    //
    final archive = ZipDecoder().decodeBuffer(inputStream);

    for (var f in archive.files) {
      // for (var f in archive) {
      final newName = DateTime.now().microsecondsSinceEpoch.toString();

      if (!f.isFile) {
        continue;
      }
      // final extension = p.extension(f.name);
      // if (!ext.contains(extension)) {
      //   continue;
      // }
      final fName = newName + p.extension(f.name);
      final destinationPath = p.join(out, fName);
      final data = f.content as List<int>;
      final outFile = File(destinationPath);
      await outFile.create();
      await outFile.writeAsBytes(data);
      response.add(FFICoverOutputResult(
          archiveName: p.basenameWithoutExtension(file),
          destinationPath: destinationPath,
          directoryFile: file));
      break;
    }
    inputStream.close();
  }

  return response;
}

Future<Book?> unzipArchiveBook(String zipPath) async {
  final List<PageEntry> pages = [];
  List<mangaLibBook.Page> pages0 = [];
  try {
    pages0 = await Future(() => mangakolektUnzipArchiveBook(zipPath));
  } catch (e) {
    print(e);
    return null;
  }
  for (var p in pages0) {
    Image image;
    try {
      image = await imageFromBytes(p.image);
    } catch (e) {
      break;
    }

    bool isDouble = false;

    if (image.width != null && image.height != null) {
      isDouble =
          (image.width! >= image.height!) || image.width! == image.height!;
    }

    pages.add(PageEntry(name: p.name, image: image, isDouble: isDouble));
  }

  return Book(
      name: p.basename(zipPath),
      pageNumber: pages.length,
      pages: pages,
      path: zipPath);
}

Future<Book?> unzipArchiveBookDart(String zipPath) async {
  List<PageEntry> pages = [];

  final openedFile = File(zipPath);
  final archiveBytes = await openedFile.readAsBytes();
  final archiveFile = ZipDecoder().decodeBytes(archiveBytes);

  for (var f in archiveFile) {
    //TODO: Remove start and end tracking evan in comment form
    // final start = DateTime.now().millisecondsSinceEpoch;
    if (!f.isFile) {
      continue;
    }
    final data = f.content;

    final image = await imageFromBytes(data);

    String imageName = f.name;
    bool isDouble = false;
    if (image.width != null &&
        image.height != null &&
        (image.width! > image.height!)) {
      isDouble = true;
    }
    pages.add(PageEntry(name: imageName, image: image, isDouble: isDouble));
    // final end = DateTime.now().millisecondsSinceEpoch;
    // print("Time per page:: ${(end - start) / 1000}");
  }
  return Book(
      name: p.basename(zipPath),
      pageNumber: pages.length,
      pages: pages,
      path: zipPath);
}
