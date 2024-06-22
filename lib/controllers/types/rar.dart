import 'dart:io';

import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/ffi/ffi.dart';
import 'package:mangakolekt/controllers/archive.dart';

class RarBookController extends BaseBookController {
  final List<String> fileTypes = ['cbr', 'rar'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      return ffiUnrarCovers(files, pathToDir, out);
    }
    return [];
  }

  @override
  Future<void> unpack(String pathToBook, String dest) async {
    try {
      await ffiUnrarSingleBook(pathToBook, dest);
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
