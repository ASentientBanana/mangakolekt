import 'dart:async';
import 'dart:io';

import 'package:mangakolekt/controllers/types/zip.dart';
import 'package:mangakolekt/models/book.dart';

abstract class BaseBookController {
  bool checkType(String type);
  Future<Book?> unpack(String pathToBook, String dest);
  Future<List<String>> unpackCovers(String pathToDir);
}

class ArchiveController {
  // Add controllers for the file types
  static List<BaseBookController> controllers = [ZipBookController()];

  static BaseBookController? getTypeController(String type) {
    for (var controller in ArchiveController.controllers) {
      if (controller.checkType(type)) {
        return controller;
      }
    }
    return null;
  }

  static FutureOr<Book?> unpack(List<String> args) async {
    //file type (eg: zip)
    final type = args[0];
    final pathToBook = args[1];
    final dest = args[2];
    final controller = ArchiveController.getTypeController(type);
    if (controller == null) {
      return null;
    }
    final b = await controller.unpack(pathToBook, dest);
    return b;
  }

  static Future<Future<List<String>> Function(String)?> unpackCovers(
    String pathToDir,
  ) async {
    final dir = Directory(pathToDir);
    final dirList = (await dir.list().toList());

    final controller =
        ArchiveController.getTypeController(dirList.last.path.split('.').last);
    if (controller == null) {
      return null;
    }
    return controller.unpackCovers;
  }
}
