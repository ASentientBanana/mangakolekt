import 'package:flutter/material.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkElement.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkMangaButton.dart';

class BookmarkContent extends StatefulWidget {
  final Bookmarks bookmarks;
  final Future<void> Function(int, int) deleteBookmarkCb;

  const BookmarkContent(
      {Key? key, required this.bookmarks, required this.deleteBookmarkCb})
      : super(key: key);

  @override
  State<BookmarkContent> createState() => _BookmarkContentState();
}

class _BookmarkContentState extends State<BookmarkContent> {
  int bookmarksIndex = 0;

  void selectBookmarks(int i) {
    setState(() {
      bookmarksIndex = i;
    });
  }

  int getItemCount() {
    if (widget.bookmarks.data.isEmpty) {
      return 0;
    }
    return widget.bookmarks.data[bookmarksIndex].bookmarks.length;
  }

  Widget builder(BuildContext context, int index) {
    return BookmarkElement(
        key: Key(widget.bookmarks.data[bookmarksIndex].bookmarks[index].date
            .toString()),
        deleteBookmarkCb: widget.deleteBookmarkCb,
        refetch: () => {},
        bookData: widget.bookmarks.data[bookmarksIndex],
        bookmarkItem: widget.bookmarks.data[bookmarksIndex].bookmarks[index]);
  }

  @override
  void initState() {
    super.initState();
    print("Printing::");
    widget.bookmarks.data.forEach((element) {print(element.name);});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 500,
      width: 1000,
      color: colorScheme.primary,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: colorScheme.secondary,
                      width: 1,
                      style: BorderStyle.solid)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Bookmarks"),
              ],
            ),
          ),
          //MainBody
          Expanded(
            child: Row(
              children: [
                //Left side
                Container(
                  width: 270,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          color: colorScheme.secondary,
                          width: 1,
                          style: BorderStyle.solid),
                    ),
                  ),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 5),
                    itemCount: widget.bookmarks.data.length,
                    itemBuilder: (context, index) => BookmarkMangaButton(
                      index: index,
                      selectBookmarkCb: selectBookmarks,
                      name: widget.bookmarks.data[index].name,
                      selected: index == bookmarksIndex,
                    ),
                  ),
                ),
                //Right side
                Expanded(
                  child: ListView.builder(
                    itemCount: getItemCount(),
                    itemBuilder: builder,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
