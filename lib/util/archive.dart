import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../util/files.dart';
import 'package:path/path.dart' as p;

Future<Book?> getBookFromArchive(String path) async {
  // final book = await File(path).readAsBytes();

  final bytes = await File(path).readAsBytes();

  final bookName = p.split(path).last;

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
    if (!entry.isFile) {
      continue;
    }
    pageNumber++;
    pages.add(
      PageEntry(
        name: entry.name,
        image: Image.memory(
          entry.content,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  return Book(
      pages: pages,
      pageNumber: pageNumber,
      name: bookName,
      path: p.dirname(path));
}

Future<String> unzipCoverBeta(String path, String out) async {
  const uuid = Uuid();
  final id = uuid.v4();
  try {
    final bytes = await File(path).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final file = archive.files.where((element) => element.isFile).first;
    final filename = file.name;
    final ext = filename.split('.').last;
    final data = file.content as List<int>;
    final stream = Stream<List<int>>.fromIterable([data]);
    // final outputPath = "$out/$id.$ext";
    final outputPath = p.join(out, "$id.$ext");
    final outFile = File(outputPath);
    final output = await outFile.create(recursive: true);
    stream.pipe(output.openWrite());
    return p.split(outputPath).last;
  } catch (e) {
    log("Err:: ${e.toString()}");
  }
  return '';
}

Future<String> unzipFiles(List<File> files, String outputPath) async {
  int numberOfItems = files.length;

  int coreCount = 1;
  int cpuLimit = Platform.numberOfProcessors - 2;
  if (numberOfItems > 1) {
    if (numberOfItems < cpuLimit) {
      coreCount = numberOfItems;
    } else {
      coreCount = cpuLimit;
    }
  }
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
  final files = args[0] as List<File>;
  final sendPort = args[1] as SendPort;
  final outputPath = args[2] as String;
  var booksString = '';
  try {
    for (final file in files) {
      final out = p.join(outputPath, currentDirName);
      final coverName = await unzipCoverBeta(file.path, out);
      booksString +=
          "${p.split(file.path).last};${p.join(out, coverName)};${file.path}&";
    }
    sendPort.send(booksString);
    return;
  } catch (e) {
    return;
  }
}

bool checkIfPathIsFile(String path, String type) {
  final file = path.split('.').last;
  if (type == 'book') {
    return supportedBookTypes.contains(file);
  }
  if (type == 'image') {
    return supportedImageTypes.contains(file);
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

Future<List<BookCover>> getBookList({String path = ""}) async {
  return [];
}

Future<bool> checkTempDir() async {
  Directory tempDir = await getTemporaryDirectory();
  return await Directory(tempDir.path).list().isEmpty;
}
