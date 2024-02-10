import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/screens/openBookError.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/reader.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';

class ReaderPageWrapper extends StatefulWidget {
  final String path;
  final int id;
  late final int initialPage;

  ReaderPageWrapper(
      {Key? key, required this.path, required this.id, int? initialPage})
      : super(key: key) {
    this.initialPage = initialPage ?? 0;
  }

  @override
  State<ReaderPageWrapper> createState() => _ReaderPageWrapperState();
}

class BookResult {
  final Book? book;
  final List<int> bookmarks;
  BookResult({required this.book, required this.bookmarks});
}

class _ReaderPageWrapperState extends State<ReaderPageWrapper> {
  Future<Book?> _book = Future(() => null);
  final _navigationService = locator<NavigationService>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
     setState(() {
        _book = getBook(context, widget.path, widget.id);
     });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _book,
        builder: (context, snapshot) {
          //Check if we got the data
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: LoadingDog(),
                  ),
                ),
              );
            }
            return OpenBookError();
          }
          // instantiate reader controller
          final readerController = ReaderController(book: snapshot.data!);
          readerController.openBook = _navigationService.pushAndPop;
          return MangaReader(
            initialPage: widget.initialPage,
            readerController: readerController,
          );
        });
  }
}
