import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/reader/double_page_grid.dart';
import 'package:mangakolekt/widgets/reader/single_page_view.dart';

import '../util/archive.dart';

class MangaReader extends StatefulWidget {
  const MangaReader({Key? key}) : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

Future<OldBook?> getBook(BuildContext context) async {
  await Future.delayed(const Duration(microseconds: 1000));
  final args = ModalRoute.of(context)!.settings.arguments as String;
  final d = await getCurrentDirPath();
  OldBook? oldBook;
  //TODO: Figure out building for windows
  if (Platform.isLinux) {
    oldBook = await compute(unzipSingleBookToCurrent, [args, d]);
  } else {
    oldBook = await getBookFromArchive(args);
  }
  return oldBook;
}

Widget builderFn(
    BuildContext context, AsyncSnapshot snapshot, ReaderState state) {
  final Widget viewWidget;

  if (state is! ReaderLoaded || !snapshot.hasData) {
    return viewWidget = const Center(
      child: SizedBox(
        child: CircularProgressIndicator(),
      ),
    );
  }
  final bookView = (state as ReaderLoaded).bookView;

  void switchDirection() {
    final bloc = context.read<ReaderBloc>();
    if (bloc.state is! ReaderLoaded) return;
    bloc.add(ToggleIsRightToLeftMode());
  }

  void handleChangePageView(bool isDoublePageView) {
    context.read<ReaderBloc>().add(ToggleDoublePageViewMode());
  }

  return Scaffold(
      appBar: AppBar(
        title: Text("book name"),
        actions: [
          TextButton(
            onPressed: () => handleChangePageView(bookView.isDoublePageView),
            child: Text(
              bookView.isDoublePageView ? "Single page" : "Double page",
              style: TEXT_STYLE_NORMAL,
            ),
          ),
          TextButton(
            onPressed: bookView.isDoublePageView ? switchDirection : null,
            child: Text(
              bookView.isRightToLeftMode ? "Left to Right" : "Right to left",
              style: bookView.isDoublePageView
                  ? TEXT_STYLE_NORMAL
                  : TEXT_STYLE_DISABLED,
            ),
          ),
          TextButton(
            onPressed: () => context.read<ReaderBloc>().add(ToggleScaleTo()),
            child: Text(
              bookView.scaleTo == ScaleTo.width
                  ? "Scale to height"
                  : "Scale to width",
              style: bookView.isDoublePageView
                  ? TEXT_STYLE_DISABLED
                  : TEXT_STYLE_NORMAL,
            ),
          ),
        ],
      ),
      body: bookView.readerView == ReaderView.single
          ? ReaderSingle(book: snapshot.data!)
          : ReaderGrid(book: snapshot.data!));
}

class _MangaReaderState extends State<MangaReader> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      // This disables the default focus behaviour
      canRequestFocus: false,
      child: FutureBuilder(
        builder: (context, snapshot) {
          return BlocBuilder<ReaderBloc, ReaderState>(
              builder: (context, state) => builderFn(context, snapshot, state));
        },
        future: getBook(context),
      ),
    );
    // return
  }
}
