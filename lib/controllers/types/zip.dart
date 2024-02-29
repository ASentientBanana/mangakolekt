import 'dart:io';

import 'package:mangakolekt/services/ffiService.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:path/path.dart' as p;
import 'package:mangakolekt/controllers/archive.dart';

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['zip', 'cbz'];

  @override
  Future<List<String>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    List<String> books;
    print("STARTING UNPACKING COVERS");
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      books = await FFIService.ffiUnzipCovers(files, pathToDir, out);
    } else {
      books = await getBooksV2(pathToDir);
    }
    return books;
  }

  // TODO: Decouple the unzip logic from loading the books
  @override
  Future<void> unpack(String pathToBook, String dest) async {
    try {
      final files = await FFIService.ffiUnzipSingleBook(pathToBook, dest);

      if (files.isEmpty) {
        return;
      }
      // await _loadBook(files, bookName, pathToBook);
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
