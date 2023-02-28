import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/Book.dart';
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

  Future<List<Book>> getBooks() async {
    var contents = Directory("/home/petar/bigboy/Manga/OnePiece");
    List<Book> books = [];
    try {
      if (await contents.exists()) {
        final contentList = await contents.list().toList();
        for (var i = 0; i < contentList.length - 1; i++) {
          // if (i > 4) break;
          final entity = contentList[i];
          if ((await entity.stat()).type == FileSystemEntityType.file) {
            final book = await getBookFromArchive(entity.path);
            if (book.name != 'none') {
              books.add(book);
            }
          }
        }
      }

      return books;
    } catch (e) {
      print("ERR");
      print(e);
      return [];
    }
  }

  Widget pageBuilder(BuildContext context, int index) {
    return images[index];
  }

  Widget bookBuilder(BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
    print(snapshot.data);
    return Wrap(
        children: snapshot.hasData
            ? snapshot.data!.map((e) {
                return Column(
                  children: [e.image, Text(e.name)],
                );
              }).toList()
            : []);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lib'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 60),
              child: FutureBuilder(
                builder: bookBuilder,
                future: getBooks(),
              ),
            )
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
