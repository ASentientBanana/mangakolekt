import 'package:flutter/material.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/models/util.dart';
import 'package:mangakolekt/widgets/appbar/backButton.dart';

class ReaderAppbar extends AppBar {
  // final bool isBookmark;

  ReaderAppbar({
    required Color isBookmarkedColor,
    required Color isNotBookmarkedColor,
    required readerController,
    required isBookmark,
    required void Function(bool) bookmark,
    required void Function(VoidCallback) set,
  }) : super(
            title: Text(readerController.book.name),
            leading: CustomBackButton(),
            actions: [
              TextButton(
                onPressed: () => bookmark(isBookmark),
                child: Icon(
                  size: 26,
                  Icons.bookmark_sharp,
                  color: isBookmark ? isBookmarkedColor : isNotBookmarkedColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  set(() {
                    readerController.toggleViewMode();
                  });
                },
                child: Text(
                  readerController.isDoublePageView
                      ? "Single page"
                      : "Double page",
                  style: TEXT_STYLE_NORMAL,
                ),
              ),
              TextButton(
                onPressed: readerController.isDoublePageView
                    ? () {
                        set(() {
                          readerController.toggleReadingDirection();
                        });
                      }
                    : null,
                child: Text(
                  readerController.isRightToLeftMode
                      ? "Right to left"
                      : "Left to Right",
                  style: readerController.isDoublePageView
                      ? TEXT_STYLE_NORMAL
                      : TEXT_STYLE_DISABLED,
                ),
              ),
              TextButton(
                onPressed: readerController.isDoublePageView
                    ? null
                    : () {
                        set(() {
                          readerController.toggleScale();
                        });
                      },
                child: Text(
                  readerController.scaleTo == ScaleTo.width
                      ? "Scale to height"
                      : "Scale to width",
                  style: readerController.isDoublePageView
                      ? TEXT_STYLE_DISABLED
                      : TEXT_STYLE_NORMAL,
                ),
              ),
            ]);
}

// AppBar(
//         title: Text(readerController.book.name),
//         actions: ,
//       )
