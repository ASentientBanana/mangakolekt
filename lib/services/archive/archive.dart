library archive_service;

import 'package:isolate_pool_2/isolate_pool_2.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/util/util.dart';
import "dart:io";
import 'package:archive/archive.dart' as archiver;
import 'package:path/path.dart' as p;
import 'package:archive/archive_io.dart';

Future<void> recreateDirectory(String directoryPath) async {
  final dir = Directory(directoryPath);
  await dir.delete(recursive: true);
  await dir.create();
}

class UnzipCoversJob extends PooledJob<List<FFICoverOutputResult>> {
  final List<String> files;
  final String out;
  UnzipCoversJob({required this.files, required this.out});

  @override
  Future<List<FFICoverOutputResult>> job() async {
    return await _unzipArchiveCovers([files, out]);
  }
}

List<List<String>> chunkify(List<String> files) {
  final List<List<String>> chunks = [];
  const numberOfChunks = 10;
  print("LOADING $numberOfChunks chunks");
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

Future<List<FFICoverOutputResult>> unzipArchiveCovers(
    IsolatePool pool, List<String> files, String out) async {
  final List<FFICoverOutputResult> result = [];

  final start = DateTime.now().millisecondsSinceEpoch;
  final chunks = chunkify(files);

  // print("Chunk 1:: SIZE:: ${c[0].length} \n ${c[0]}");
  // print("Chunk 2:: SIZE:: ${c[1].length} \n ${c[1]}");
  // print("Chunk 3:: SIZE:: ${c[2].length} \n ${c[2]}");

  // final res =compute(
  //     (message) =>
  //         _unzipArchiveCovers(message[0] as List<String>, message[1] as String),
  //     [files, out]);

  final List<Future> futures = [];
  for (var i = 0; i < chunks.length; i++) {
    final chunk = chunks[i];

    futures.add(pool.scheduleJob<List<FFICoverOutputResult>>(
        UnzipCoversJob(files: chunk, out: out)));
  }

  final List<dynamic> results = await Future.wait(futures);
  for (var i = 0; i < results.length; i++) {
    result.addAll(results[i]);
  }

  final end = DateTime.now().millisecondsSinceEpoch;
  print("Unzip finished complete in ${(end - start) / 1000}s");
  return result;
}

Future<List<FFICoverOutputResult>> _unzipArchiveCovers(
    List<dynamic> props) async {
  final List<String> files = props[0];
  final String out = props[1];
  const ext = [".jpg", ".jpeg", ".png", ".gif"];
  final List<FFICoverOutputResult> response = [];
  final start = DateTime.now().millisecondsSinceEpoch;

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
      final extension = p.extension(f.name);
      if (!ext.contains(extension)) {
        continue;
      }
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

  final end = DateTime.now().millisecondsSinceEpoch;
  print("Unzip finished in ${(end - start) / 1000}s");
  return response;
}

Future<Book?> unzipArchiveBook(String zipPath, String dest) async {
  final openedFile = File(zipPath);
  final archiveBytes = await openedFile.readAsBytes();
  final archiveFile = archiver.ZipDecoder().decodeBytes(archiveBytes);
  // await recreateDirectory(dest);

  final List<PageEntry> pages = [];

  for (var f in archiveFile) {
    print(f.name);
    if (!f.isFile) {
      print("dir: ${f.name}");
      continue;
    }

    final data = f.content;

    final image = await imageFromBytes(data);

    String imageName = f.name;
    bool isDouble = false;
    if (image.width != null &&
        image.height != null &&
        (image.width! > image.height!)) {
      // final split = f.name.split('.');
      // image.
      // split.insert(1, "__wide__");
      // imageName = split.join('');
      isDouble = true;
    }
    pages.add(PageEntry(name: imageName, image: image, isDouble: isDouble));

    // final outputFile = File(p.join(dest, imageName));
    // await outputFile.create(recursive: true);
    // await outputFile.writeAsBytes(data);
  }
  return Book(
      name: p.basename(zipPath),
      pageNumber: pages.length,
      pages: pages,
      path: zipPath);
}
