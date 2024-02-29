import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
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
    bookmarks = DatabaseMangaHelpers.getBookmarks();
  }

  Future<void> deleteBookmark(int manga, int page) async {
    await DatabaseMangaHelpers.removeBookmark(manga: manga, page: page);
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
      return SizedBox(
        width: 700,
        height: 500,
        child: Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      );
    }

    if (!snapshot.hasData) {
      return BookmarkContent(
        deleteBookmarkCb: deleteBookmark,
        bookmarks: Bookmarks.Empty(),
      );
    }
    print((snapshot.data as Bookmarks).data);
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              backgroundColor: MaterialStatePropertyAll(colorScheme.onPrimary),
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
