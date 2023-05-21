import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/reader/grid.dart';
import 'package:mangakolekt/widgets/reader/single.dart';
import '../util/archive.dart';

class MangaReader extends StatefulWidget {
  MangaReader({Key? key}) : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  Future<OldBook?> getBook(BuildContext context) async {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    final oldBook = await getBookFromArchive(args);
    return oldBook;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      // This disables the default focus behaviour
      canRequestFocus: false,
      child: FutureBuilder(
        builder: (context, snapshot) {
          return BlocBuilder<ReaderBloc, ReaderState>(
              builder: (context, state) {
            if (state is ReaderLoaded && snapshot.hasData) {
              final readerView = state.bookView.readerView;
              if (readerView == ReaderView.single) {
                return ReaderSingle(book: snapshot.data!);
              }
              if (readerView == ReaderView.grid) {
                return ReaderGrid(book: snapshot.data!);
              }
            }
            return const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            );
          });
        },
        future: getBook(context),
      ),
    );
    // return
  }
}
