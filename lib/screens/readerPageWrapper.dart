import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/settings.dart';
import 'package:mangakolekt/screens/loadingScreen.dart';
import 'package:mangakolekt/screens/mobile/reader.dart';
import 'package:mangakolekt/screens/openBookError.dart';
import 'package:mangakolekt/screens/reader.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:mangakolekt/util/reader.dart';

class ReaderPageWrapper extends StatefulWidget {
  final String path;
  final int id;
  int libraryId;
  late final int initialPage;

  ReaderPageWrapper(
      {super.key,
      required this.path,
      required this.id,
      int? initialPage,
      this.libraryId = -1}) {
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
  final _settingsService = locator<Settings>();

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
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return OpenBookError();
          }
          //Check if we got the data
          if (snapshot.connectionState != ConnectionState.done) {
            return LoadingScreen();
          }
          // instantiate reader controller
          final readerController = ReaderController(book: snapshot.data!);
          readerController.openBook = _navigationService.pushAndPop;
          readerController.loadSettings(_settingsService);
          if (isMobile()) {
            return MangaReaderMobile(
              initialPage: widget.initialPage,
              readerController: readerController,
              libraryId: widget.libraryId,
            );
          }
          return MangaReader(
            libraryId: widget.libraryId,
            initialPage: widget.initialPage,
            readerController: readerController,
          );
        });
  }
}
