import 'package:flutter/material.dart';
import 'dart:async';

import 'package:mangakolekt_archive_lib/mangakolekt_archive_lib.dart'
    as mangakolekt_archive_lib;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int sumResult;
  late Future<int> sumAsyncResult;

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleTestClick() async {
    const path = "/home/petar/bigboy/Manga/Holyland/Holyland - Volume_01.cbz";
    const out = "/out.png";
    mangakolekt_archive_lib.mangakolektUnzipArchiveLib(path, out);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: handleTestClick, child: const Text("TEST"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
