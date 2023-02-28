import 'package:flutter/material.dart';
import 'package:mangakolekt/screens/lib.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import './constants.dart';

void main() {
  runApp(const MyApp());
}

// TODO: Posibly move this to a init state later? It may be called too much.
Future<void> initTmpDir() async {
  Directory tempDir = await getTemporaryDirectory();
  // var listener = tempDir.list(recursive: false, followLinks: false);
  var tmp = Directory("${tempDir.path}/$tmpDirName");
  var tmpBooks = Directory("${tempDir.path}/$tmpDirName/books");
  var tmpBook = Directory("${tempDir.path}/$tmpDirName/book");

  print("creating base dir");
  await tmp.create();
  print("creating book dir");
  await tmpBook.create();
  print("creating books dir");
  await tmpBooks.create();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initTmpDir();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const MyHomePage(),
        '/reader': (context) => MangaReader(),
        // '/reader': (context) =>
      },
    );
  }
}
