import 'dart:io';

import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/ffiService.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/controllers/archive.dart';

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['zip', 'cbz'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      return FFIService.ffiUnzipCovers(files, pathToDir, out);
    }
    return [];
  }

  // TODO: Decouple the unzip logic from loading the books
  @override
  Future<void> unpack(String pathToBook, String dest) async {
    try {
      final files = await FFIService.ffiUnzipSingleBook(pathToBook, dest);
      if (files.isEmpty) {
        return;
      }
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
