import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import '../../screens/reader.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/files.dart';

class ReaderPageWrapper extends StatelessWidget {
  const ReaderPageWrapper({Key? key}) : super(key: key);

  Future<Book?> getBook(BuildContext context) async {
    print("test render");
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final d = await getCurrentDirPath();
    Book? oldBook;
    imageCache.clear();
    if (Platform.isLinux || Platform.isWindows) {
      oldBook = await compute(unzipSingleBookToCurrent, [args, d]);
    } else {
      oldBook = await getBookFromArchive(args);
    }
    return oldBook;
  }

  @override
  Widget build(BuildContext context) {
    print("test render 2");

    final _books = getBook(context);
    return FutureBuilder(
        future: _books,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return MangaReader(
            book: snapshot.data!,
          );
        });
  }
}
