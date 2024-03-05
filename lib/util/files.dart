import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mangakolekt/models/global.dart';
import '../constants.dart';
import 'package:path/path.dart' as p;

Future<String?> pickDirectory() async {
  return await FilePicker.platform.getDirectoryPath();
}

Future<String?> pickFile() async {
  final file = await FilePicker.platform.pickFiles(allowMultiple: false);
  if (file != null && file.count > 0) {
    return file.paths.first;
  }
  return null;
}

Future<void> createAppFolder() async {
  final appDir = Directory(p.join(Global.appDocumentsDir, Global.mangaDirName));
  if (!(await appDir.exists())) {
    await appDir.create(recursive: true);
  }
}

Future<int> getNumberOfFiles(String path) async {
  final dir = Directory(path);
  int filesCount = 0;
  if (!(await dir.exists())) {
    return filesCount;
  }
  final contents = await dir.list().toList();
  final len = contents.length;
  for (var i = 0; i < len; i++) {
    final stat = await contents[i].stat();
    if (stat.type == FileSystemEntityType.file) {
      filesCount++;
    }
  }
  return filesCount;
}

Future<void> createLogFile() async {
  final f =
      File(p.join(Global.appDocumentsDir, Global.mangaDirName, logFilePath));
  if (!(await f.exists())) {
    await f.create();
  }
}

Future<void> log(String msg) async {
  final logPath = p.join(Global.mangaDirName, logFilePath);
}

Future<String> getCurrentDirPath() async {
  return p.join(
      Global.appDocumentsDir, Global.mangaDirName, Global.currentDirName);
}

Future<void> createCurrentDir() async {
  final d = Directory(await getCurrentDirPath());
  if (!(await d.exists())) {
    await d.create();
  }
}

Future<void> createGlobalCoversDir() async {
  final path =
      p.join(Global.appDocumentsDir, Global.mangaDirName, Global.coversDirName);
  final d = Directory(path);
  if (!(await d.exists())) {
    await d.create();
  }
}

Future<String> getGlobalCoversDir() async {
  final path =
      p.join(Global.appDocumentsDir, Global.mangaDirName, Global.coversDirName);
  return path;
}

Future<void> emptyCurrentDir() async {
  final path = p.join(
      Global.appDocumentsDir, Global.mangaDirName, Global.currentDirName);
  final d = Directory(path);
  if (!(await d.exists())) {
    await d.create();
    return;
  }
  await d.delete(recursive: true);
  await d.create();
}

Future<List<String>> getFilesFromDir(Directory dir) async {
  final list = await dir.list().toList();
  final List<String> files = [];
  print("Number of files ${list.length} in ${dir.path}");
  for (var i = 0; i < list.length; i++) {
    if ((await list[i].stat()).type == FileSystemEntityType.file) {
      files.add(list[i].path);
    }
  }
  return files;
}

Future<void> deleteFiles(List<String> files) async {
  print("Files marked for deletion: \n ${files}");
  for (var file in files) {
    await File(file).delete();
  }
}
