import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:path_provider/path_provider.dart';
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

Future<void> createGlobalCoversDir() async {
  final appDocs = await getApplicationDocumentsDirectory();
  final path = p.join(appDocs.path, 'covers');
  final d = Directory(path);
  if (!(await d.exists())) {
    await d.create();
  }
}

Future<String> getGlobalCoversDir() async {
  final appDocs = await getApplicationDocumentsDirectory();
  final path = p.join(appDocs.path, 'covers');
  return path;
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
