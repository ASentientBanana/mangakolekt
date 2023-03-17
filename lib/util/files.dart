import 'dart:io';
import 'package:file_picker/file_picker.dart';

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

Future<void> createLibFolder(String path) async {
  //scan dir
  final dir = Directory("$path/$libFolederName");
  final coversDir =
      Directory("$path/$libFolederName/$libFolderCoverFolderName");
  final mapFile = File("$path/$libFolederName/$libFolderMapFile");
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
  final books = getBooks(path);
  print(books);
}
