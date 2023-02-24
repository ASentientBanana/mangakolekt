import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mangakolekt/util/files.dart';
import '../util/archive.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Image> images = [];

  Future<void> testPath() async {
    final d = await getTemporaryDirectory();
  }

  @override
  void initState() {
    //TOOD: get all volumes from folder
    // getFilesFromLib();
    testPath();
    super.initState();
  }

  Widget pageBuilder(BuildContext context, int index) {
    return images[index];
  }

  Widget bookBuilder(BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
    return Wrap(
        children: snapshot.hasData
            ? snapshot.data!.map((e) {
                return Column(
                  children: [Image.file(File(e.path)), Text(e.title)],
                );
              }).toList()
            : []);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lib'),
        ),
        body: Center(
            child: FutureBuilder(
                future: extractCoverImage('/home/petar/bigboy/Manga/One Piece'),
                builder: bookBuilder))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
