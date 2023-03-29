import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/widgets/reader_appbar.dart';
import 'package:mangakolekt/widgets/reader_page.dart';

import '../util/archive.dart';

class MangaReader extends StatefulWidget {
  MangaReader({Key? key}) : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  int numberOfPages = 0;
  bool isDoublePageView = false;
  bool isRightToLeftMode = false;
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

  List<Widget> createDoubleView(List<PageEntry> list) {
    if (!isRightToLeftMode) {
      return list
          .map((e) => ReaderPage(
                item: e,
                isGridView: true,
              ))
          .toList();
    } else {
      final len = list.length;
      for (var i = 0; i < len; i++) {
        if (i + 1 < len && i % 2 == 0) {
          swap(list, i, i + 1);
        }
      }
      return list
          .map((e) => ReaderPage(
                item: e,
                isGridView: true,
              ))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // numberOfPages = snapshot.data!.pageNumber;
          return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data!.name),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isDoublePageView = !isDoublePageView;
                        });
                      },
                      child: const Text(
                        "Double page",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: isDoublePageView
                          ? () {
                              setState(() {
                                isRightToLeftMode = !isRightToLeftMode;
                              });
                            }
                          : null,
                      child: const Text(
                        "Right to left",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              body: Center(
                child: GridView.count(
                  crossAxisCount: isDoublePageView ? 2 : 1,
                  primary: false,
                  children: createDoubleView(snapshot.data!.pages),
                ),
              ));
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
