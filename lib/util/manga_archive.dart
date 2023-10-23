import 'dart:io';

import 'package:mangakolekt/util/archive.dart';

abstract class ArchiveController {
  final List<String> fileTypes;
  final String path;

  ArchiveController({required this.path, required this.fileTypes});

  Future<List<String>> unzip();
}

class DefaultController extends ArchiveController {
  DefaultController(String _path, List<String> _fileTypes)
      : super(path: _path, fileTypes: _fileTypes);

  @override
  Future<List<String>> unzip() async {
    final dir = Directory(path);
    if (!(await dir.exists())) return [];
    final dirContents = await dir.list().toList();
    final List<File> files = [];
    for (var element in dirContents) {
      if (checkIfPathIsFile(element.path, 'book')) {
        files.add(File(element.path));
      }
    }
    // final files = (await dir.list().toList()).map((e) => File(e.path)).toList();
    final coverString = await unzipFiles(files, path);
    final bookCovers = coverString.split('&').where((element) => element != '');
    return bookCovers.toList();
  }
}
