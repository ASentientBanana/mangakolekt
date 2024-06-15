import 'dart:io';

import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/constants.dart';
import 'package:image/image.dart' as dart_img;

class ZipBookController extends BaseBookController {
  final List<String> fileTypes = ['cbr', 'rar'];

  @override
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out}) async {
    return [];
  }

  // TODO: Decouple the unzip logic from loading the books
  @override
  Future<void> unpack(String pathToBook, String dest) async {}

  @override
  bool checkType(String type) {
    return fileTypes.contains(type);
  }
}
