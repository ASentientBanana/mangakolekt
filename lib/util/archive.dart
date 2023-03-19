import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

const String libFolderName = '.mangaKolektLib';
const String libCoverFolderName = '.mangaKolektLib';

Future<BookCover?> getCoverFromArchive(String path, target) async {
  // final book = await File(path).readAsBytes();

  final bookName = path.split('/').last;

  Directory tempDir = await getTemporaryDirectory();

  final bytes = await File(path).readAsBytes();
  // Decode the Zip file
  final Archive archive;

  // Check to see if file can be decoded or is corupted
  try {
    archive = ZipDecoder().decodeBytes(bytes, verify: true);
  } catch (e) {
    return null;
  }

// Extract the contents of the Zip archive to disk.
  final coverArchive = archive.files.where((e) => e.isFile).first;

  final out = '${tempDir.path}/$libFolderName/$libCoverFolderName/${bookName}';

  final data = coverArchive.content as List<int>;

  final f = await File(out).create(recursive: true);
  await f.writeAsBytes(data, flush: true);

  return BookCover(name: bookName, path: out);
}

Future<Book?> getBookFromArchive(String path) async {
  // final book = await File(path).readAsBytes();

  Directory tempDir = await getTemporaryDirectory();

  final bytes = await File(path).readAsBytes();
  // Decode the Zip file
  final bookName = path.split('/').last;
  final Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes, verify: true);
  } catch (e) {
    return null;
  }

  // Extract the contents of the Zip archive to disk.
  for (final file in archive) {
    final out = '${tempDir.path}/$tmpBooks/$bookName/${file.name}';
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
            image: Image.file(
              File(cover.path),
              height: 80,
              width: 60,
            ),
            status: BookReadStatus.unread,
            read: 23);
      }
    }
  }
  return null;
}

Future<List<BookCover>> getBooks(String path) async {
  // TODO: Add a target path for dumping images, read mapper file return Cover
  final contents = Directory("$path/$libFolderName/$libCoverFolderName");
  // Target here
  List<BookCover> books = [];
  try {
    if (await contents.exists()) {
      final contentList = await contents.list().toList();
      for (var i = 0; i < contentList.length; i++) {
        //For testing. Need to make this more user friendly
        if (i > 6) break;
        final entity = contentList[i];
        if ((await entity.stat()).type == FileSystemEntityType.file) {
          final book = await getCoverFromArchive(
              //TODO: add target instead of empty string
              entity.path,
              '');
          if (book != null) books.add(book);
        }
      }
    }
    return books;
  } catch (e) {
    return [];
  }
}

Future<List<Book>> getBookList({String path = ""}) async {
  return [];
}

Future<bool> checkTempDir() async {
  Directory tempDir = await getTemporaryDirectory();
  return await Directory(tempDir.path).list().isEmpty;
}
