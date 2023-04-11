import 'dart:io';
import 'dart:math';
import 'dart:isolate';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';

Future<BookCover?> getCoverFromArchive(String path, target) async {
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
}

typedef void Callback();

Future<String> unzipFiles(List<File> files, String outputPath) async {
  final chunkSize = (files.length / 3).ceil();
  final chunks = [
    files.sublist(0, chunkSize),
    files.sublist(chunkSize, chunkSize * 2),
    files.sublist(chunkSize * 2),
  ];

  List<String> coverString = [];
  final receivePorts = List<ReceivePort>.generate(3, (_) => ReceivePort());

  final isolateFutures = List<Future>.generate(
      3,
      (i) => Isolate.spawn(_unzipFilesInIsolate,
          [chunks[i], receivePorts[i].sendPort, outputPath]));
  await Future.wait(isolateFutures);
  for (final port in receivePorts) {
    print('1');
    await for (final message in port) {
      if (message is String) {
        coverString.add(message);
        port.close();
      } else {
        break;
      }
    }
    port.close();
  }
  return coverString.join('');
}

void _unzipFilesInIsolate(List<dynamic> args) async {
    var uuid = Uuid();
  final files = args[0] as List<File>;
  final sendPort = args[1] as SendPort;
  final outputPath = args[2] as String;
  var booksString = '';
  try {
    for (final file in files) {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final coverArchive = archive.files.where((e) => e.isFile).first;

    final data = coverArchive.content as List<int>;
    final coverName = coverArchive.name.split('/').last;
    final coverExtension = coverArchive.name.split('/').last.split('.').last;
    final id = uuid.v4();
    final filename = "$id.$coverExtension";
    final out =
        '$outputPath/$libFolderName/$libFolderCoverFolderName/$filename';
    await File(out).create(recursive: true);
    await File(out).writeAsBytes(data, flush: true);
    // print(object)
    // name;coverPath;bookPath;
    // return BookCover(name: bookName, path: out, bookPath: path);
    print(out);
    booksString +=
        "$coverName;$out;${file.path}&";
  }
  sendPort.send(booksString);
   return;
  } catch (e) {
    return;
  }
}

Future<List<String>> getBooksV2(String path, {Callback? cb}) async {
  final dir = Directory(path);
  if (!(await dir.exists())) return [];
  final dirContents = await dir.list().toList();
  final List<File> files = [];
  for (var element in dirContents) {
    if((await element.stat()).type == FileSystemEntityType.file){
      files.add(File(element.path));
    }
  }
  // final files = (await dir.list().toList()).map((e) => File(e.path)).toList();  
  final coverString = await unzipFiles(files, path);
  final bookCovers = coverString.split('&').where((element) => element != '');
  print(coverString);
  return bookCovers.toList();
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
              path);
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
