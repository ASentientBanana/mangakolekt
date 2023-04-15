import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';

Future<String?> getCoverFromArchive(String path, target) async {
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

  final coverName = coverArchive.name.split('/').last.split('.').last;

  final out =
      '$target/$libFolderName/$libFolderCoverFolderName/${DateTime.now().millisecondsSinceEpoch}.$coverName';

  final data = coverArchive.content as List<int>;

  final f = await File(out).create(recursive: true);
  await f.writeAsBytes(data, flush: true);
  return "$bookName;$out;$path";
  // return BookCover(name: bookName, path: out, bookPath: path);
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

Future<String> unzipFiles(List<File> files, String outputPath) async {
  int numberOfItems = files.length;

  // final chunkSize = (files.length / isolateCount).ceil();
  // print("ISO::: $numberOfItems :: $chunkSize :: $isolateCount");

  // final chunks = genChunks(files, isolateCount, chunkSize);

  // TODO: this can be changed later to spawn isolates based on the core count.
  print("${files.length}...$outputPath");
  const coreCount = 3;
  final chunkSize = (numberOfItems / coreCount).floor();
  final numberOfChunks = (numberOfItems / chunkSize).floor();

  final chunks = List.generate(
    numberOfChunks,
    (i) {
      try {
        return files.sublist(
            i * chunkSize, (i + 1) * chunkSize.clamp(0, numberOfItems));
      } catch (e) {
        return [];
      }
    },
  ).where((element) => element.isNotEmpty).toList();
  chunks[numberOfChunks - 1] = files.sublist((numberOfChunks - 1) * chunkSize,
      (numberOfChunks * chunkSize).clamp(0, numberOfItems));
  final n = chunks.length;
  final receivePorts = List<ReceivePort>.generate(n, (_) => ReceivePort());
  final isolateFutures = List<Future>.generate(
      n,
      (i) => Isolate.spawn(_unzipFilesInIsolate,
          [chunks[i], receivePorts[i].sendPort, outputPath]));

  await Future.wait(isolateFutures);
  final futures = receivePorts.map((port) => port.first).toList();
  final results = await Future.wait(futures);
  return results.join('');
}

void _unzipFilesInIsolate(List<dynamic> args) async {
  const uuid = Uuid();
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
      final coverName = file.path.split('/').last;
      final coverExtension = coverArchive.name.split('/').last.split('.').last;
      final id = uuid.v4();
      final filename = "$id.$coverExtension";
      final out =
          '$outputPath/$libFolderName/$libFolderCoverFolderName/$filename';
      await File(out).create(recursive: true);
      await File(out).writeAsBytes(data, flush: true);
      booksString += "$coverName;$out;${file.path}&";
    }
    sendPort.send(booksString);
    return;
  } catch (e) {
    return;
  }
}

bool checkIfPathIsFile(String path, String type) {
  if (type == 'book') {
    return supportedBookTypes.contains(path.split('.').last);
  }
  if (type == 'image') {
    return supportedImageTypes.contains(path.split('.').last);
  }
  return false;
}

Future<List<String>> getBooksV2(String path, {void Function()? cb}) async {
  final dir = Directory(path);
  if (!(await dir.exists())) return [];
  final dirContents = await dir.list().toList();
  final List<File> files = [];
  for (var element in dirContents) {
    if (checkIfPathIsFile(element.path, 'book')) {
      files.add(File(element.path));
    }
  }
  // final files = (await dir.list().toList()).map((e) => File(e.path)).toList();
  final coverString = await unzipFiles(files, path);
  final bookCovers = coverString.split('&').where((element) => element != '');
  return bookCovers.toList();
}

Future<List<String>> getBooks(String path, {void Function()? cb}) async {
  // TODO: Add a target path for dumping images, read mapper file return Cover
  final contents = Directory(path);
  // Target here
  List<String> books = [];
  try {
    if (await contents.exists()) {
      final contentList = await contents.list().toList();
      for (var i = 0; i < contentList.length; i++) {
        //For testing. Need to make this more user friendly
        // if (i > 6) break;
        final entity = contentList[i];
        if (checkIfPathIsFile(entity.path, 'image')) {
          final book = await getCoverFromArchive(
            //TODO: add target instead of empty string
            entity.path,
            path,
          );
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
