import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
import '../../screens/reader.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/files.dart';
// import 'package:sky_engine/ui/ui.dart' as dart_paint;
// sky_engine/lib/ui/painting.dart

class ReaderPageWrapper extends StatelessWidget {
  const ReaderPageWrapper({Key? key}) : super(key: key);

  Future<Book?> getBook(BuildContext context) async {
    final bookPath = ModalRoute.of(context)!.settings.arguments as String;
    final dest = await getCurrentDirPath();
    Book? book;
    imageCache.clear();

    if (Platform.isLinux || Platform.isWindows) {
      book = await compute(
          ArchiveController.unpack, [bookPath.split('.').last, bookPath, dest]);
    } else {
      book = await getBookFromArchive(bookPath);
    }

    final dirList = await Directory(dest).list().toList();

    // print("Size: ${imageData.width}x${imageData.height} = ${imageData.dispose()}");
    return book;
  }

  @override
  Widget build(BuildContext context) {
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
