import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:path/path.dart';

class BookmarkElement extends StatefulWidget {
  final Bookmark bookmarkItem;
  final BookmarksData bookData;
  final void Function(int, int) deleteBookmarkCb;
  BookmarkElement(
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(left: 15),
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
                        "path": join(
                            widget.bookData.path, widget.bookmarkItem.book),
                        "id": widget.bookData.id,
                      });
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      widget.bookmarkItem.book,
                      overflow: TextOverflow.ellipsis,
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
          const SizedBox(
            width: 15,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                    color: colorScheme.secondary,
                    width: 1,
                    style: BorderStyle.solid),
              ),
            ),
            child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() {
                          _isLoading = true;
                          widget.deleteBookmarkCb(
                              widget.bookData.id, widget.bookmarkItem.page);
                        });
                      },
                child: const Icon(Icons.delete)),
          ),
        ],
      ),
    );
  }
}
