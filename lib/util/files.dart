import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:path_provider/path_provider.dart';
import './util.dart';
import '../constants.dart';
import './archive.dart';

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
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");

  if (!(await mapFile.exists())) {
    await mapFile.create(recursive: true);
  }
}

Future<List<BookCover>> readAppDB() async {
  // on linux its '/home/petar/Documents'
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");
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
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");
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

typedef void Callback();

Future<void> createLibFolder(String path, {Callback? cb}) async {
  //scan dir
  final dir = Directory("$path/$libFolderName");
  final coversDir = Directory("$path/$libFolderName/$libFolderCoverFolderName");
  final mapFile = File("$path/$libFolderName/$libFolderMapFile");
  // final libFilderExists = await dir.exists();

  // // Create expected dirs
  await dir.create();
  await coversDir.create();
  await mapFile.create();

  //maper format is filename;path
  final start = DateTime.now().millisecondsSinceEpoch;
  final books = await getCoversFromDir(path: path);
  // final books = await getBooksV2(path, cb: cb);
  final end = DateTime.now().millisecondsSinceEpoch;

  final folderName = path.split('/').last;

  await log("$folderName: ${(end - start) / 1000} seconds");
  // final covers = books.map((element) {
  //   return "${element.name};${element.path};${element.bookPath}";
  // }).toList();
  await mapFile.writeAsString(books.join('\n'));
}

Future<List<BookCover>> readFromLib(BookCover liBook) async {
  final dir = Directory("${liBook.path}/$libFolderName");
  final coversDir =
      Directory("${liBook.path}/$libFolderName/$libFolderCoverFolderName");
  final mapFile = File("${liBook.path}/$libFolderName/$libFolderMapFile");
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
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");

  if (await mapFile.exists()) {
    final contents = await mapFile.readAsString();
    final contentList = contents.split('\n');
    contentList.removeAt(index);
    final newContents = contentList.join('\n');
    await mapFile.writeAsString(newContents);
  }

  final libDir = Directory("${libString.split(';')[1]}/$libFolderName");
  print("Delet dir:: $libDir");
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
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");
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
  final libDir = Directory("$path/$libFolderName");
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
  final f = File("${dirPath.path}/$appFolder/$logFilePath");
  if (!(await f.exists())) {
    await f.create();
  }
}

Future<void> log(String msg) async {
  final dirPath = await getApplicationDocumentsDirectory();

  final f = File("${dirPath.path}/$logFilePath");
  if (await f.exists()) {
    await f.writeAsString("$msg\n", mode: FileMode.append);
  }
}

Future<List<ThemeStore>> readThemeFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final filePath = "${dirPath.path}/$appFolder/$themeFileName";
  var input = await File(filePath).readAsString();
  Map<String, dynamic> map = jsonDecode(input);
  List<dynamic> themes = map['themes'];
  return themes.map((e) => ThemeStore.fromJSON(e)).toList();
}

Future<List<ThemeStore>> createThemeFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final filePath = "${dirPath.path}/$appFolder/$themeFileName";

  final f = await File(filePath).create(recursive: true);
  final themes = ThemeStore.generateDefaultThemes();
  await f.writeAsString(
      '{ "current": 0, "themes":[${themes.map((e) => jsonEncode(e.toJSON())).join(',')} ]}');

  return themes;
}

Future<List<ThemeStore>> checkThemeFile() async {
  final dirPath = await getApplicationDocumentsDirectory();
  final filePath = "${dirPath.path}/$appFolder/$themeFileName";
  if (await File(filePath).exists()) {
    return await readThemeFile();
  } else {
    return await createThemeFile();
  }
}
