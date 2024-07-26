library archive_service;

import 'package:mangakolekt/models/ffi.dart';
import "dart:io";
import 'package:archive/archive.dart' as archiver;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:archive/archive_io.dart';

Future<void> recreateDirectory(String directoryPath) async {
  final dir = Directory(directoryPath);
  await dir.delete(recursive: true);
  await dir.create();
}

Future<List<FFICoverOutputResult>> unzipArchiveCovers(
    List<String> files, String out) async {
  const ext = [".jpg", ".jpeg", ".png", ".gif"];
  final List<FFICoverOutputResult> response = [];
  for (var i = 0; i < files.length; i++) {
    final file = files[i];

    // final openedFile = File(file);
    final inputStream = InputFileStream(file);
    // final archiveFile = await openedFile.readAsBytes();
    // final archive = ZipDecoder().decodeBytes(await openedFile.readAsBytes());
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
  }
  return response;
}

Future<void> unzipArchiveBook(String zipPath, String dest) async {
  final openedFile = File(zipPath);
  final archiveBytes = await openedFile.readAsBytes();
  final archiveFile = archiver.ZipDecoder().decodeBytes(archiveBytes);
  await recreateDirectory(dest);

  for (var f in archiveFile) {
    if (!f.isFile) {
      continue;
    }

    final data = f.content as List<int>;

    final outputFile = File(p.join(dest, f.name));
    await outputFile.create(recursive: true);
    await outputFile.writeAsBytes(data);
  }
}
