import 'package:flutter/material.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/models/util.dart';
// import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/widgets/appbar/backButton.dart';

class ReaderAppbarMobile extends AppBar {
  ReaderAppbarMobile({
    required Color isBookmarkedColor,
    required Color isNotBookmarkedColor,
    required readerController,
    required isBookmark,
    required void Function() bookmark,
    required void Function(VoidCallback) set,
  }) : super(
            title: Text(readerController.book.name),
            // leading: CustomBackButton(),
            actions: [
              Builder(builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return PopupMenuButton(
                    icon: Icon(Icons.more_vert_rounded,
                        color: colorScheme.tertiary),
                    color: colorScheme.background,
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(
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
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: readerController.isDoublePageView
                                  ? () {
                                      set(() {
                                        readerController
                                            .toggleReadingDirection();
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
                          ),
                          PopupMenuItem(
                            child: TextButton(
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
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: bookmark,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Bookmark",
                                    style: TEXT_STYLE_NORMAL,
                                  ),
                                  Icon(
                                    size: 26,
                                    isBookmark
                                        ? Icons.bookmark_added_sharp
                                        : Icons.bookmark_outline_sharp,
                                    color: isBookmark
                                        ? isBookmarkedColor
                                        : isNotBookmarkedColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]);
              })
            ]);
}
