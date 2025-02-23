import 'dart:io';

import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/util/files.dart';

abstract class BaseBookController {
  List<String> fileTypes = [];
  bool checkType(String type);
  Future<Book?> unpack(String pathToBook, String dest);
  Future<List<FFICoverOutputResult>> unpackCovers(String pathToDir,
      {required List<String> files, required String out});
}

class ArchiveController {
  static List<BaseBookController> controllers = [];

  static Map<String, int> controllerMap = {};

  static void registerControllers(List<BaseBookController> _controllers) {
    final int index = controllers.length;
    for (var c in _controllers) {
      controllers.add(c);
      for (var t in c.fileTypes) {
        if (controllerMap[t] == null) {
          controllerMap[t] = index;
        }
      }
    }
  }

  static bool isSupportedType(type) {
    return controllerMap[type] != null;
  }

  static BaseBookController? getControllerForType(type) {
    final controllerIndex = controllerMap[type];
    if (controllerIndex == null) {
      return null;
    }
    final controller = controllers[controllerIndex];
    return controller;
  }

  static Future<Book?> unpack(String path,
      {String? type, required String dest, String? id}) async {
    String _type = type ?? extractType(path);
    return await getControllerForType(_type)?.unpack(path, dest);
  }

  static Future<List<FFICoverOutputResult>> unpackCovers(
      String path, String outputPath) async {
    final dir = Directory(path);
    final files = await getFilesFromDir(dir);
    final Set<String> typeSet = {};

    for (var file in files) {
      final type = extractType(file);
      typeSet.add(type);
    }

    final List<FFICoverOutputResult> covers = [];
    for (var type in typeSet) {
      final _covers = await getControllerForType(type)
          ?.unpackCovers(path, files: files, out: outputPath);
      if (_covers != null) {
        covers.addAll(_covers);
      }
    }
    return covers;
  }
}
