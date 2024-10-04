import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/archive/archive.dart';
import 'package:mangakolekt/services/ffi/ffi.dart';
import 'package:mangakolekt/controllers/archive.dart';

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['zip', 'cbz'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      try {
        final start = DateTime.now().millisecondsSinceEpoch;
        final res =
            await compute((message) => ffiUnzipCovers(message), [files, out]);

        // final res = await compute(
        // (message) => unzipArchiveCoversDart(message), [files, out]);
        final end = DateTime.now().millisecondsSinceEpoch;
        print("Time to unzip all covers:: ${(end - start) / 1000}");
        return res;
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  // TODO: Decouple the unzip logic from loading the books
  @override
  Future<Book?> unpack(String pathToBook, String dest) async {
    try {
      return await unzipArchiveBook(pathToBook);
      return await unzipArchiveBookDart(pathToBook);
    } catch (e) {
      print("Problbem with ffi");
      print(e);
    }
  }

  @override
  bool checkType(String type) {
    return fileTypes.contains(type);
  }
}
