import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/services/navigation_service.dart';
import 'package:mangakolekt/util/util.dart';
import '../../screens/reader.dart';
import 'package:mangakolekt/util/archive.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:path_provider/path_provider.dart';

class ReaderPageWrapper extends StatefulWidget {
  final String path;
  final int id;

  const ReaderPageWrapper({Key? key, required this.path, required this.id})
      : super(key: key);

  @override
  State<ReaderPageWrapper> createState() => _ReaderPageWrapperState();
}

class _ReaderPageWrapperState extends State<ReaderPageWrapper> {
  Future<Book?> _book = Future(() => null);
  final _navigationService = locator<NavigationService>();
  // List<String> _books = [];
  // List<>

  Future<Book?> getBook(String bookPath) async {
    final dest = await getCurrentDirPath();
    Book? book;
    imageCache.clear();

    if (Platform.isLinux || Platform.isWindows) {
      final params = [bookPath.split('.').last, bookPath, dest];
      book = await compute(ArchiveController.unpack, params);
      // try {
      // } catch (e) {
      //   //fallback
      //   print(e);
      // }
    } else {
      book = await getBookFromArchive(bookPath);
    }
    return book;
  }

  @override
  void initState() {
    print("Opened id: ${widget.id}");
    _book = getBook(widget.path);
    super.initState();
  }

  Future<void> updateBook(String path, int direction) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      return;
    }
    final _dirContents = (await dir.list().toList());
    final List<String> dirContents = [];
    for (var i = 0; i < _dirContents.length; i++) {
      if ((await _dirContents[i].stat()).type == FileSystemEntityType.file) {
        dirContents.add(_dirContents[i].path);
      }
    }
    final target = (await _book);
    if (target == null) {
      return;
    }
    final sorted = sortNumeric(dirContents);
    final currentIndex = sorted.indexWhere((e) => e == widget.path);

    if (currentIndex == sorted.length - 1 ||
        (currentIndex == 0 && direction < 0) ||
        currentIndex < 0 ||
        sorted.isEmpty) {
      return;
    }
    _navigationService.pushAndPop(
        '/reader', {"path": dirContents[currentIndex + direction], "id": 0});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _book,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Scaffold(
              body: InkWell(
                  onTap: () {
                    _navigationService.goBack();
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Unable to open book',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 25),
                        ),
                        Text(
                          'Click to go back',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 17),
                        )
                      ],
                    ),
                  )),
            );
          }
          return MangaReader(
            id: widget.id,
            updateBook: updateBook,
            book: snapshot.data!,
          );
        });
  }
}
