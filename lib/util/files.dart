import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:path_provider/path_provider.dart';
import './util.dart';
import '../constants.dart';
import './archive.dart';
import 'package:path/path.dart' as p;

String Function(String) getMapFilePath =
    (String path) => p.join(path, appFolder, appMapFile);

Future<List<File>> getFileListFromDir(String path) async {
  Directory d = Directory(path);
  var files = d.list();
  return files.map((elem) {
    return File(elem.path);
  }).toList();
}

Future<String?> pickDirectory() async {
  return await FilePicker.platform.getDirectoryPath();
}

Future<void> createAppDB() async {
  // on linux its '/home/petar/Documents'
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File(p.join(appDocumentDir.path, appFolder, appMapFile));
  if (!(await mapFile.exists())) {
    await mapFile.create(recursive: true);
  }
}

typedef Callback = void Function();

Future<void> registerBookToLib(String libPath, bookPath) async {}

Future<int> getNumberOfFiles(String path) async {
  final dir = Directory(path);
  int filesCount = 0;
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

Future<bool> deleteLibbyIndex(String libString, int index) async {
  //template name;path;bookPath
  //check if app mapFile and lib mapFile exist;
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File(getMapFilePath(appDocumentDir.path));

  if (await mapFile.exists()) {
    final contents = await mapFile.readAsString();
    final contentList = contents.split('\n');
    contentList.removeAt(index);
    final newContents = contentList.join('\n');
    await mapFile.writeAsString(newContents);
  }
  final libDir = Directory(p.join(libString.split(';')[1], libFolderName));
  if (await libDir.exists()) {
    await libDir.delete(
      recursive: true,
    );
  }
  return true;
}

Future<bool> deleteLib(String path) async {
  //template name;path;bookPath
  //check if app mapFile and lib mapFile exist;

  // final libDir = Directory("$path/$libFolderName");
  final libDir = Directory(p.join(path, libFolderName));
  if (await libDir.exists()) {
    await libDir.delete(recursive: true);
  }
  return true;
}

Future<void> createLogFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final f = File(p.join(dirPath.path, appFolder, logFilePath));
  if (!(await f.exists())) {
    await f.create();
  }
}

Future<void> log(String msg) async {
  final logPath = p.join(appFolder, logFilePath);
}

Future<List<ThemeStore>> readThemeFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final filePath = p.join(dirPath.path, appFolder, themeFileName);
  var input = await File(filePath).readAsString();
  Map<String, dynamic> map = jsonDecode(input);
  List<dynamic> themes = map['themes'];
  return themes.map((e) => ThemeStore.fromJSON(e)).toList();
}

Future<List<ThemeStore>> createThemeFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final filePath = p.join(dirPath.path, appFolder, themeFileName);

  final f = await File(filePath).create(recursive: true);
  final themes = ThemeStore.generateDefaultThemes();
  await f.writeAsString(
      '{ "current": 0, "themes":[${themes.map((e) => jsonEncode(e.toJSON())).join(',')} ]}');

  return themes;
}

Future<List<ThemeStore>> checkThemeFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final filePath = p.join(dirPath.path, appFolder, themeFileName);
  if (await File(filePath).exists()) {
    return await readThemeFile();
  } else {
    return await createThemeFile();
  }
}

Future<String> getCurrentDirPath() async {
  final dirPath = await getApplicationDocumentsDirectory();
  return p.join(dirPath.path, appFolder, currentFolder);
}

Future<void> createCurrentDir() async {
  final d = Directory(await getCurrentDirPath());
  if (!(await d.exists())) {
    await d.create();
  }
}

Future<void> emptyCurrentDir() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final path = p.join(dirPath.path, appFolder, currentFolder);
  final d = Directory(path);
  if (!(await d.exists())) {
    await d.create();
    return;
  }
  await d.delete(recursive: true);
  await d.create();
}
