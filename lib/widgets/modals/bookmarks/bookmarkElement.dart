import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:path/path.dart';

class BookmarkElement extends StatefulWidget {
  final Bookmark bookmarkItem;
  final BookmarksData bookData;
  final void Function(int, int) deleteBookmarkCb;
  const BookmarkElement(
      {Key? key,
      required this.bookmarkItem,
      required this.bookData,
      required this.deleteBookmarkCb})
      : super(key: key);

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
    // setState(() {
    //   _isLoading = false;
    // });
    super.dispose();
  }

  void handleDelete() async {
    print(widget.bookmarkItem.id);
    print(widget.bookData.path);
    setState(() {
      _isLoading = true;
    });
    widget.deleteBookmarkCb(widget.bookmarkItem.id, widget.bookmarkItem.page);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;
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
                        "path": join(widget.bookData.path),
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
                  Tooltip(
                    message: widget.bookmarkItem.book,
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
            child: ElevatedButton(
                onPressed: _isLoading ? null : handleDelete,
                child: const Icon(Icons.delete)),
          ),
        ],
      ),
    );
  }
}
