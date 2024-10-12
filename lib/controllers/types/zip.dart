import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/archive/archive.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/services/ffi/zip.dart';

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['zip', 'cbz'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      try {
        if (Platform.isWindows) {
          return await compute(
              (message) => unzipArchiveCoversDart(message), [files, out]);
        }
        return await compute(
            (message) => ffiUnzipCovers(message), [files, out]);
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<Book?> unpack(String pathToBook, String dest) async {
    try {
      if (Platform.isWindows) {
        return await unzipArchiveBookDart(pathToBook);
      }
      return await unzipArchiveBook(pathToBook);
    } catch (e) {
      return null;
    }
  }

  @override
  bool checkType(String type) {
    return fileTypes.contains(type);
  }
}
