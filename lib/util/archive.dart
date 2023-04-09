import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:isolate_pool_2/isolate_pool_2.dart' as isoPool;
import 'package:mangakolekt/models/book.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';

Future<BookCover?> getCoverFromArchive(
    String path, target, Callback? cb) async {
  // final book = await File(path).readAsBytes();

  final bookName = path.split('/').last;

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

  //TODO: I need to change the name of the covers
  final coverName = coverArchive.name.split('/').last.split('.').last;

  final out =
      '${target}/$libFolderName/$libFolderCoverFolderName/${DateTime.now().millisecondsSinceEpoch}.$coverName';

  final data = coverArchive.content as List<int>;

  final f = await File(out).create(recursive: true);
  await f.writeAsBytes(data, flush: true);
  if (cb != null) cb();
  return BookCover(name: bookName, path: out, bookPath: path);
}

Future<Book?> getBookFromArchive(String path) async {
  // final book = await File(path).readAsBytes();

  final bytes = await File(path).readAsBytes();
  // Decode the Zip file
  final bookName = path.split('/').last;
  final Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes, verify: true);
  } catch (e) {
    return null;
  }
  final len = archive.files.length;
  int pageNumber = 0;
  List<PageEntry> pages = [];
  for (var i = 0; i < len; i++) {
    final entry = archive.files[i];
    if (entry.isFile) {
      pageNumber++;
      pages.add(PageEntry(
          name: entry.name,
          image: Image.memory(
            entry.content,
            fit: BoxFit.contain,
          )));
    }
  }

  return Book(pages: pages, pageNumber: pageNumber, name: bookName);
  // Extract the contents of the Zip archive to disk.
  // for (final file in archive) {
  //   final out = '${tempDir.path}/$tmpBooks/$bookName/${file.name}';
  //   final Directory d;

  //   if (!file.isFile) {
  //     d = await Directory(out).create(recursive: true);
  //   } else {
  //     d = Directory('');
  //     final data = file.content as List<int>;
  //     final f = await File(out).create(recursive: true);
  //     await f.writeAsBytes(data, flush: true);
  //   }

  //   if (!(await d.exists())) break;
  //   final l = await d.list().toList();
  //   final len = l.length;

  // }
  return null;
}

typedef void Callback();

// Future<Book>

class CoverGenerator extends isoPool.PooledInstance {
  @override
  Future init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future receiveRemoteCall(isoPool.Action action) {
    // TODO: implement receiveRemoteCall
    throw UnimplementedError();
  }
}

Future<List<BookCover>> getBooksForSlice(
    List<String> contentList, Callback? cb, String target) async {
  final List<BookCover> books = [];
  for (var i = 0; i < contentList.length; i++) {
    //For testing. Need to make this more user friendly
    // if (i > 6) break;
    final entity = contentList[i];
    final book = await getCoverFromArchive(entity, target, null);
    if (cb != null && book != null) {
      books.add(book);
      cb();
    }
  }
  print("Done");
  return books;
}

Future<List<BookCover>> getBooksV2(String path, {Callback? cb}) async {
  // TODO: Add a target path for dumping images, read mapper file return Cover
  final contents = Directory(path);
  // Target here
  List<BookCover> books = [];
  final List<Future<BookCover?>> jobs = [];
  try {
    if (await contents.exists()) {
      final contentList = await contents.list().toList();
      for (var i = 0; i < contentList.length; i++) {
        //For testing. Need to make this more user friendly
        // if (i > 6) break;
        final entity = contentList[i];
        if ((await entity.stat()).type == FileSystemEntityType.file) {
          jobs.add(getCoverFromArchive(
              //TODO: add target instead of empty string
              entity.path,
              path,
              cb));
          // if (book != null) books.add(book);
        }
      }
    }
    final b = await Future.wait(jobs);
    for (var i = 0; i < b.length; i++) {
      if (b[i] != null) {
        books.add(b[i]!);
      }
    }
    return books;
  } catch (e) {
    return [];
  }
}

Future<List<BookCover>> getBooks(String path, {Callback? cb}) async {
  // TODO: Add a target path for dumping images, read mapper file return Cover
  final contents = Directory(path);
  // Target here
  List<BookCover> books = [];
  try {
    if (await contents.exists()) {
      final contentList = await contents.list().toList();
      for (var i = 0; i < contentList.length; i++) {
        //For testing. Need to make this more user friendly
        // if (i > 6) break;
        final entity = contentList[i];
        if ((await entity.stat()).type == FileSystemEntityType.file) {
          final book = await getCoverFromArchive(
              //TODO: add target instead of empty string
              entity.path,
              path,
              null);
          if (cb != null) {
            cb();
          }
          if (book != null) books.add(book);
        }
      }
    }
    return books;
  } catch (e) {
    return [];
  }
}

Future<List<BookCover>> getBookList({String path = ""}) async {
  return [];
}

Future<bool> checkTempDir() async {
  Directory tempDir = await getTemporaryDirectory();
  return await Directory(tempDir.path).list().isEmpty;
}
