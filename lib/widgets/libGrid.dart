import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/models/Book.dart';
import '../util/archive.dart';

class LibGrid extends StatefulWidget {
  const LibGrid({super.key});

  @override
  State<LibGrid> createState() => _LibGridState();
}

class _LibGridState extends State<LibGrid> {
  Future<List<Book>> loadTitles() async {
    List<Book> covers = [];
    var dir = Directory('/home/petar/bigboy/Manga/Holyland');
    if (!(await dir.exists())) return [];

    final contents = await dir.list().toList();
    for (var element in contents) {
      var fStat = (await element.stat());
      if (fStat.type == FileSystemEntityType.file) {
        // TODO: Check if in supported list;
        final cover = await getCoverFromArchive(element.path);
        if (cover != null) {
          covers.add(cover);
        }
      }
    }
    // TODO: Take a look at this later.
    covers.sort((Book a, Book b) => a.name.compareTo(b.name));
    return covers;
  }

  @override
  void initState() {
    loadTitles();
    super.initState();
  }

  // List<Book> books = await getBooks('~/bigboy/Manga/Holyland');
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.orange,
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    padding: const EdgeInsets.all(20),
                    primary: false,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: snapshot.data!.map((e) => e.image).toList());
              } else {
                return const Text('loading...');
              }
            },
            future: loadTitles()));
  }
}
