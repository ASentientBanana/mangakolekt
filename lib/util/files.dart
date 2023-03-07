import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

Future<List<File>> getFileListFromDir() async {
  Directory d = Directory('/home/petar/bigboy/Manga/One Piece');
  var files = d.list();
  return files.map((elem) {
    return File(elem.path);
  }).toList();
}

Future<void> createLibFolder(String path) async {
  //scan dir
  var dir = Directory(path);
  var list = dir.list();
  list.forEach((element) {
    print(element);
  });
// check if
}
