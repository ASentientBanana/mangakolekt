import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/services/navigationService.dart';
// import 'package:mangakolekt/util/lib.dart';

class BookmarkElement extends StatefulWidget {
  final Bookmark bookmarkItem;
  final BookmarksData bookData;
  final Future<void> Function(int, int) deleteBookmarkCb;
  final void Function() refetch;

  const BookmarkElement(
      {super.key,
      required this.bookmarkItem,
      required this.bookData,
      required this.refetch,
      required this.deleteBookmarkCb});

  @override
  State<BookmarkElement> createState() => _BookmarkElementState();
}

class _BookmarkElementState extends State<BookmarkElement> {
  final _navigationService = locator<NavigationService>();
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.hour}:${dateTime.minute}/${dateTime.day}.${dateTime.month}.${dateTime.year}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleDelete() async {
    setState(() {
      _isLoading = true;
    });
    print(
        "For:: bookmark id: ${widget.bookmarkItem.id} and page: ${widget.bookmarkItem.page}");
    await widget.deleteBookmarkCb(
        widget.bookmarkItem.id, widget.bookmarkItem.page);
    widget.refetch();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;
    final isNotInLib = widget.bookmarkItem.book == "-1";
    return Container(
      padding: const EdgeInsets.only(left: 15),
      height: isWide ? 30 : 90,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: colorScheme.secondary, width: 1, style: BorderStyle.solid),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _isLoading
                  ? null
                  : () {
                      _navigationService.pushAndPop('/reader', {
                        "initialPage": widget.bookmarkItem.page,
                        "path": widget.bookData.path,
                        "libraryId": -1,
                        "id": widget.bookData.id,
                      });
                    },
              child: Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: isWide
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isNotInLib
                      ? Text("Not in library")
                      : Tooltip(
                          message:
                              "${widget.bookData.name} [${widget.bookmarkItem.page}]",
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              widget.bookmarkItem.book,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  Text("Page: ${widget.bookmarkItem.page + 1}"),
                  Text(
                    formatDateTime(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.bookmarkItem.date),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isWide
              ? const SizedBox.shrink()
              : const SizedBox(
                  width: 15,
                ),
          Container(
            height: isWide ? 30 : 90,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: colorScheme.secondary,
                    width: 1,
                    style: BorderStyle.solid),
              ),
            ),
            child: InkWell(
              onTap: _isLoading ? null : handleDelete,
              child: SizedBox(
                width: 50,
                child: Icon(Icons.delete, color: colorScheme.secondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
