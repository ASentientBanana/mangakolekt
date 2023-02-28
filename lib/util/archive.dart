import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/Book.dart';
// import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

Future<Book> getBookFromArchive(String path) async {
  // final book = await File(path).readAsBytes();

  Directory tempDir = await getTemporaryDirectory();

  final bytes = await File(path).readAsBytes();
  // Decode the Zip file

  final archive = ZipDecoder().decodeBytes(bytes);

  // Extract the contents of the Zip archive to disk.
  for (final file in archive) {
    final out = '${tempDir.path}/$tmpBooks/${file.name}';
    final Directory d;

    if (!file.isFile) {
      d = await Directory(out).create(recursive: true);
    } else {
      d = Directory('');
      final data = file.content as List<int>;
      final f = await File(out).create(recursive: true);
      await f.writeAsBytes(data, flush: true);
    }

    if (!(await d.exists())) break;
    final l = await d.list().toList();
    final len = l.length;
    for (var i = 0; i < len; i++) {
      if (!(i == len - 1)) continue;
      final cover = l[i];
      if (await cover.exists()) {
        return Book(
            name: path,
            image: Image.file(File(cover.path)),
            status: BookReadStatus.unread,
            read: 23);
      }
    }
  }
  return Book(
      name: 'none',
      image: Image.network(""),
      status: BookReadStatus.unread,
      read: 23);
}

Future<List<Book>> getBookList({String path = ""}) async {
  return [];
}

Future<bool> checkTempDir() async {
  Directory tempDir = await getTemporaryDirectory();
  return await Directory(tempDir.path).list().isEmpty;
}
