import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/widgets/reader_appbar.dart';
import 'package:mangakolekt/widgets/reader_page.dart';

import '../util/archive.dart';
import '../widgets/reader_grid.dart';

class MangaReader extends StatefulWidget {
  MangaReader({Key? key}) : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  //TODO: Add init state to scan for open manga
  @override
  void initState() {
    super.initState();
  }

  Future<Book?> getBook(BuildContext context) async {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final book = await getBookFromArchive(args);
    return book;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // numberOfPages = snapshot.data!.pageNumber;
          return ReaderGrid(book: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      //TODO: complete the future
      future: getBook(context),
    );
    // return
  }
}
