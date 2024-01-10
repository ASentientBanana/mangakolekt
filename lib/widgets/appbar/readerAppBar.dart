import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/appbar/backButton.dart';

class ReaderAppBar extends StatefulWidget {
  final String bookName;
  final ReaderController readerController;

  ReaderAppBar(
      {Key? key, required this.bookName, required this.readerController})
      : super(key: key);

  @override
  State<ReaderAppBar> createState() => _ReaderAppBarState();
}

class _ReaderAppBarState extends State<ReaderAppBar> {
  @override
  Widget build(BuildContext context) {
    final readerBloc = context.read<ReaderBloc>().state as ReaderLoaded;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(widget.bookName),
      leading: CustomBackButton(),
      actions: [
        TextButton(
          // onPressed: bookmark,
          onPressed: () {},
          child: Icon(
            size: 26,
            Icons.bookmark_sharp,
            color: readerBloc.bookmarks
                    .contains(widget.readerController.currentPageIndex)
                ? colorScheme.tertiary
                : colorScheme.onPrimary,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.readerController.toggleViewMode();
            });
          },
          child: Text(
            widget.readerController.isDoublePageView
                ? "Single page"
                : "Double page",
            style: TEXT_STYLE_NORMAL,
          ),
        ),
        TextButton(
          onPressed: widget.readerController.isDoublePageView
              ? () {
                  setState(() {
                    widget.readerController.toggleReadingDirection();
                  });
                }
              : null,
          child: Text(
            widget.readerController.isRightToLeftMode
                ? "Right to left"
                : "Left to Right",
            style: widget.readerController.isDoublePageView
                ? TEXT_STYLE_NORMAL
                : TEXT_STYLE_DISABLED,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.readerController.toggleScale();
            });
          },
          child: Text(
            widget.readerController.scaleTo == ScaleTo.width
                ? "Scale to height"
                : "Scale to width",
            style: widget.readerController.isDoublePageView
                ? TEXT_STYLE_DISABLED
                : TEXT_STYLE_NORMAL,
          ),
        ),
      ],
    );
  }
}
