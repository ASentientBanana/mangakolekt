import 'package:flutter/material.dart';
import 'package:mangakolekt/constants.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/models/util.dart';
// import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/widgets/appbar/backButton.dart';

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar(
      {required this.controller,
      required this.isBookmarkedColor,
      required this.isNotBookmarkedColor,
      required this.readerController,
      required this.isBookmark,
      required this.bookmark,
      required this.set,
      this.isHidden = false});

  final AnimationController controller;
  final Color isBookmarkedColor;
  final Color isNotBookmarkedColor;
  final ReaderController readerController;
  final bool isBookmark;
  final void Function() bookmark;
  final void Function(VoidCallback) set;
  final bool isHidden;

  List<PopupMenuEntry<dynamic>> menuBuilder(BuildContext context) {
    return [
      PopupMenuItem(
        onTap: () {
          set(() {
            readerController.toggleViewMode();
          });
        },
        child: Text(
          readerController.isDoublePageView ? "Single page" : "Double page",
          style: TEXT_STYLE_NORMAL,
        ),
      ),
      PopupMenuItem(
        onTap: readerController.isDoublePageView
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
      PopupMenuItem(
        onTap: readerController.isDoublePageView
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
      PopupMenuItem(
        onTap: bookmark,
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
              color: isBookmark ? isBookmarkedColor : isNotBookmarkedColor,
            )
          ],
        ),
      ),
    ];
  }

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    !isHidden ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: AppBar(
        title: Text(readerController.book.name),
        actions: [
          Builder(builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return PopupMenuButton(
                icon:
                    Icon(Icons.more_vert_rounded, color: colorScheme.tertiary),
                color: colorScheme.background,
                itemBuilder: menuBuilder);
          })
        ],
      ),
    );
  }
}

// Widget renderReaderAppBar(
//     {required Color isBookmarkedColor,
//     required Color isNotBookmarkedColor,
//     required readerController,
//     required isBookmark,
//     required void Function() bookmark,
//     required void Function(VoidCallback) set,
//     bool isHidden = false}) {

//   return SlideTransition(
//     position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -1)).animate(
//         CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
//       ),
//     child: AppBar(
//         title: Text(readerController.book.name),
//         // leading: CustomBackButton(),

//         actions: [
//           Builder(builder: (context) {
//             final colorScheme = Theme.of(context).colorScheme;
//             return PopupMenuButton(
//                 icon:
//                     Icon(Icons.more_vert_rounded, color: colorScheme.tertiary),
//                 color: colorScheme.background,
//                 itemBuilder: menuBuilder);
//           })
//         ]),
//   );
// }
