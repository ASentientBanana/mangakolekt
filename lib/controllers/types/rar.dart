import 'dart:io';

import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/ffiService.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/constants.dart';
import 'package:image/image.dart' as dart_img;

class RarBookController extends BaseBookController {
  final List<String> fileTypes = ['cbr', 'rar'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    if (Platform.isLinux || Platform.isWindows || Platform.isAndroid) {
      return FFIService.ffiUnrarCovers(files, pathToDir, out);
    }
    return [];
  }

  @override
  Future<void> unpack(String pathToBook, String dest) async {
    try {
      await FFIService.ffiUnrarSingleBook(pathToBook, dest);
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
