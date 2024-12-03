import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkContent.dart';

class BookmarksBody extends StatefulWidget {
  final void Function() dismissCb;

  const BookmarksBody({Key? key, required this.dismissCb}) : super(key: key);

  @override
  State<BookmarksBody> createState() => _BookmarksBodyState();
}

class _BookmarksBodyState extends State<BookmarksBody> {
  final _navigationService = locator<NavigationService>();
  Future<Bookmarks?> bookmarks = Future(() => null);

  void getBookmarks() {
    bookmarks = DatabaseMangaHelpers.getAllBookmarks();
  }

  Future<void> deleteBookmark(int book, int page) async {
    await DatabaseMangaHelpers.removeBookmark(book, page);
    setState(() {
      getBookmarks();
    });
  }

  @override
  void initState() {
    getBookmarks();
    super.initState();
  }

  Widget builder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return BookmarkContent(bookmarks: Bookmarks.Empty(), deleteBookmarkCb:(_,__)async{});
    }

    if (!snapshot.hasData) {
      return BookmarkContent(
        deleteBookmarkCb: deleteBookmark,
        bookmarks: Bookmarks.Empty(),
      );
    }
    return BookmarkContent(
      deleteBookmarkCb: deleteBookmark,
      bookmarks: snapshot.data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        FutureBuilder(future: bookmarks, builder: builder),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton(
            style: const ButtonStyle().copyWith(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
            ),
            onPressed: () {
              _navigationService.goBack();
            },
            child: const Center(
              child: Text(
                "Close",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
