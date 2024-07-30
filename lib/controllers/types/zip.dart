import 'dart:io';

import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/archive/archive.dart';
import 'package:mangakolekt/services/ffi/ffi.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/services/toast.dart';
import 'package:mangakolekt/util/platform.dart';

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['zip', 'cbz'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      try {
        if (isAbleToLoadDynamicLib()) {
          return ffiUnzipCovers(files, pathToDir, out);
        } else {
          return unzipArchiveCovers(files, out);
        }
      } catch (e) {
        MangaToast("Problem loading covers");
      }
    }
    return [];
  }

  // TODO: Decouple the unzip logic from loading the books
  @override
  Future<Book?> unpack(String pathToBook, String dest) async {
    try {
      return await unzipArchiveBook(pathToBook, dest);
      // if (isAbleToLoadDynamicLib()) {
      //   await ffiUnzipSingleBook(pathToBook, dest);
      // } else {
      // }
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
