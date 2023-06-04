import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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

Future<List<BookCover>> readAppDB() async {
  // on linux its '/home/petar/Documents'
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File(getMapFilePath(appDocumentDir.path));
  final mapContents = await mapFile.readAsString();
  final books =
      mapContents.split('\n').where((element) => element != '').map((e) {
    final splitElem = e.split(';');
    return BookCover(name: splitElem[0], path: splitElem[1], bookPath: "");
  }).toList();
  return books;
}

Future<List<BookCover>> addToAppDB(String name, path) async {
  // on linux its '/home/petar/Documents'
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File(getMapFilePath(appDocumentDir.path));
  final mapContents = await mapFile.readAsString();
  final newMap =
      mapContents.split('\n').where((element) => element != '').toList();
  newMap.add("$name;$path");
  final fileContents = newMap.join('\n');
  await mapFile.writeAsString(fileContents);
  //TODO: This should be optimized its bad now
  final books =
      mapContents.split('\n').where((element) => element != '').map((e) {
    final splitElem = e.split(';');
    return BookCover(name: splitElem[0], path: splitElem[1], bookPath: "");
  }).toList();
  return books;
}

typedef Callback = void Function();

Future<void> createLibFolder(
  String path,
) async {
  //scan dir
  final dir = Directory(p.join(path, libFolderName));
  final coversDir =
      Directory(p.join(path, libFolderName, libFolderCoverFolderName));
  final mapFile = File(p.join(path, libFolderName, libFolderMapFile));
  // // Create expected dirs
  await dir.create();
  await coversDir.create();
  await mapFile.create();

  //maper format is filename;path
  // final start = DateTime.now().millisecondsSinceEpoch;
  final books = await getCoversFromDir(path: path);
  // final books = await getBooksV2(path, cb: cb);
  // final end = DateTime.now().millisecondsSinceEpoch;

  // final folderName = p.split(path).last;
  // try {
  //   // final dirPath = await getApplicationDocumentsDirectory();
  //   await log("$folderName: ${(end - start) / 1000} seconds");
  // } catch (e) {
  //   print(e);
  // }
  await mapFile.writeAsString(books.join('\n'));
}

Future<List<BookCover>> readFromLib(BookCover libBook) async {
  final dir = Directory(p.join(libBook.path, libFolderName));
  final coversDir =
      Directory(p.join(libBook.path, libFolderName, libFolderCoverFolderName));
  final mapFile = File(p.join(libBook.path, libFolderName, libFolderMapFile));

  final libFolderExists = await dir.exists();
  final coversDirExits = await coversDir.exists();
  final mapFileExists = await mapFile.exists();

  //Check if everything exists;
  if (!libFolderExists && !coversDirExits && !mapFileExists) {}
  final mapContents = await mapFile.readAsString();

  final covers = mapContents
      .split('\n')
      .map((e) => e.split(";"))
      .where((element) => element.isNotEmpty)
      .map((e) => BookCover(name: e[0], path: e[1], bookPath: e[2]))
      .toList();

  // covers.sort(sortCovers);
  return sortCoversNumeric(covers.toList());
}

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

Future<bool> deleteLib(String libString) async {
  //template name;path;bookPath
  //check if app mapFile and lib mapFile exist;
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File(getMapFilePath(appDocumentDir.path));
  final splitLibString = libString.split(';')[1];
  String path = splitLibString;
  if (!(await mapFile.exists())) return false;
  final contents = await mapFile.readAsString();
  //This may be a problem if user wants same lib as multiple entries
  final splitContents = contents.split('\n');
  final len = splitContents.length;
  for (var i = 0; i < len; i++) {
    final element = splitContents[i];
    if ("$element;".compareTo(libString) == 0) {
      splitContents.removeAt(i);
      break;
    }
    await mapFile.writeAsString(splitContents.join('\n'));
  }
  // final libDir = Directory("$path/$libFolderName");
  final libDir = Directory(p.join(path, libFolderName));
  if (await libDir.exists()) {
    await libDir.delete(recursive: true);
    print("removed map from $path");
  }
  return true;
}

Future<List<BookCover>> loadTitles(BookCover? libBook) async {
  if (libBook?.path == '' || libBook == null) return [];
  final lib = await readFromLib(libBook);
  return lib;
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
  // final dirPath = await getApplicationDocumentsDirectory();
  // print("test");
  // print(appFolder);
  // print(logFilePath);
  print(logPath);

  // final f = File(logPath);

  // if (await f.exists()) {
  //   await f.writeAsString("$msg\n", mode: FileMode.append);
  // }
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
