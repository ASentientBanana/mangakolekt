import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';

import '../util/archive.dart';

class MangaReader extends StatefulWidget {
  MangaReader({Key? key}) : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

Future<Book?> getBook(BuildContext context) async {
  final args = ModalRoute.of(context)!.settings.arguments as String;
  final book = await getBookFromArchive(args);
  return book;
}

class _MangaReaderState extends State<MangaReader> {
  int numberOfPages = 0;
  //TODO: Add init state to scan for open manga
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          final pages = [];
          if (snapshot.hasData) {
            // numberOfPages = snapshot.data!.pageNumber;

            return Center(
              child: ListView(
                children: snapshot.data!.pages.map((e) => e.image).toList(),
              ),
            );
          } else {
            return const Center(
              child: Text('No book selected'),
            );
          }
        },
        //TODO: complete the future
        future: getBook(context),
      ),
    );
  }
}
