import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import './archive.dart';

Future<List<File>> getFileListFromDir() async {
  Directory d = Directory('/home/petar/bigboy/Manga/One Piece');
  var files = d.list();
  return files.map((elem) {
    return File(elem.path);
  }).toList();
}

Future<bool> checkIfSuportedFile({String? path, String? name}) async {
  if (name != null) return supportedTypes.contains(name.trim().split('.').last);
  if (path != null) return supportedTypes.contains(path.trim().split('.').last);
  return false;
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

Future<List<String>> readAppDB() async {
  // on linux its '/home/petar/Documents'
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");
  final mapContents = await mapFile.readAsString();
  return mapContents.split('\n').where((element) => element != '').toList();
}

Future<void> addToAppDB(String path) async {
  // on linux its '/home/petar/Documents'
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final mapFile = File("${appDocumentDir.path}/mangakolekt/$appMapFile");
  final mapContents = await mapFile.readAsString();
  final newMap =
      mapContents.split('\n').where((element) => element != '').toList();
  newMap.add(path);
  final fileContents = newMap.join('\n');
  await mapFile.writeAsString(fileContents);
}

Future<void> createLibFolder(String path) async {
  //scan dir
  final dir = Directory("$path/$libFolderName");
  final coversDir = Directory("$path/$libFolderName/$libFolderCoverFolderName");
  final mapFile = File("$path/$libFolderName/$libFolderMapFile");
  final libFilderExists = await dir.exists();
  if (libFilderExists) {
    print("Folder exists");
    return;
  }

  // Create expected dirs
  await dir.create();
  await coversDir.create();
  await mapFile.create();

  //maper format is filename;path
  print("Start map::");
  final books = await getBooks(path);
  books.forEach((element) {
    print(element.name);
    print(element.name);
  });
  print("End map::");
}

Future<void> readFromLib(path) async {
  final dir = Directory("$path/$libFolderName");
  final coversDir = Directory("$path/$libFolderName/$libFolderCoverFolderName");
  final mapFile = File("$path/$libFolderName/$libFolderMapFile");
  final libFilderExists = await dir.exists();

  if (!libFilderExists) return;
}

Future<void> registerBookToLib(String libPath, bookPath) async {}
