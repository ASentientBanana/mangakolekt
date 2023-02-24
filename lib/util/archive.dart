import 'dart:io';

import 'package:archive/archive_io.dart';
// import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<List<ArchiveFile>> openArchive() async {
  Directory tempDir = await getTemporaryDirectory();
  final target = File('/home/petar/Projects/mangakolekt/lib/util/test.cbz');
  final fileBytes = await target.readAsBytes();
  final archive = ZipDecoder().decodeBytes(fileBytes);
  for (var file in archive.files) {
    if (file.isFile) {
      final out = '${tempDir.path}/manga/${file.name.replaceAll(' ', '-')}';
      final outputStream = OutputFileStream(out);
      file.writeContent(outputStream);
      outputStream.close();
      file.decompress();
    }
  }
  return archive.files;
}

Future<List<String>> openArchiveAsStream(String path) async {
  Directory tempDir = await getTemporaryDirectory();
  final inputStream = InputFileStream(path);
  final archive = ZipDecoder().decodeBuffer(inputStream);
  List<String> _images = [];
  for (var file in archive.files) {
    if (file.isFile) {
      final out = '${tempDir.path}/manga/${file.name.replaceAll(' ', '-')}';
      final outputStream = OutputFileStream(out);
      _images.add(out);
      file.writeContent(outputStream);
      print(file.name);
      outputStream.close();
    }
  }
  inputStream.close();
  return _images;
}

class Book {
  final String title;
  final String type;
  final String path;

  Book({required this.title, required this.type, required this.path});
}

const String bookLocation = '/tmp/manga/_covers/';

Future<List<Book>> extractCoverImage(String path) async {
  var dir = Directory(path);
  var contents = dir.list();

  List<Book> books = [];

  int s = 0;

  contents.forEach((element) {
    if (s < 4) {
      final inputStream = InputFileStream(element.path);
      final archive = ZipDecoder().decodeBuffer(inputStream);
      if (!archive.files[0].isFile) {
        inputStream.close();
        return;
      }
      final archiveFile = archive.files[0];
      print(archiveFile.name);
      final out = bookLocation + archiveFile.name;
      final outputStream = OutputFileStream(out);
      archiveFile.writeContent(outputStream);
      books.add(Book(title: archiveFile.name, type: '', path: out));
      inputStream.close();
      outputStream.close();
    }
    s++;

    // books.add(Book(title: element., type: type, path: path));
  });
  return books;
}

Future<bool> checkTempDir() async {
  Directory tempDir = await getTemporaryDirectory();
  return await Directory(tempDir.path).list().isEmpty;
}
