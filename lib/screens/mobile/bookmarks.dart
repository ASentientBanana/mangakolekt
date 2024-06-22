import 'package:flutter/material.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkElement.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkMangaButton.dart';

class BookmarksMobile extends StatefulWidget {
  const BookmarksMobile({Key? key}) : super(key: key);

  @override
  _BookmarksMobileState createState() => _BookmarksMobileState();
}

class _BookmarksMobileState extends State<BookmarksMobile> {
  Future<Bookmarks?> bookmarksFuture = Future(() => null);
  int bookmarkIndex = 0;

  void getBookmarks() {
    setState(() {
      bookmarksFuture = DatabaseMangaHelpers.getBookmarks();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getBookmarks();
    super.initState();
  }

  Widget bookmarkElementBuilder(BookmarksData item, int index) {
    return BookmarkElement(
        bookmarkItem: item.bookmarks[index],
        bookData: item,
        deleteBookmarkCb: (_, __) {});
  }

  Widget futureContentBuilder(
      BuildContext context, AsyncSnapshot<Bookmarks?> snapshot) {

    if (!snapshot.hasData) {
      return const Text("No bookmarks loaded");
    }

    if (snapshot.data!.data.isEmpty) {
      return const Text("No bookmarks added");
    }

    return ListView.builder(
      itemCount: snapshot.data?.data[bookmarkIndex].bookmarks.length ?? 0,
      itemBuilder: ((context, index) =>
          bookmarkElementBuilder(snapshot.data!.data[bookmarkIndex], index)),
    );
  }

  Widget futureListBuilder(
      BuildContext context, AsyncSnapshot<Bookmarks?> snapshot) {
    if (!snapshot.hasData) {
      return const Drawer();
    }

    if (snapshot.data!.data.isEmpty) {
      return const Drawer();
    }

    return Drawer(
      child: ListView.builder(
        itemCount: snapshot.data!.data.length,
        itemBuilder: (context, index) => BookmarkMangaButton(
          name: snapshot.data!.data[bookmarkIndex].name,
          index: index,
          selected: index == bookmarkIndex,
          selectBookmarkCb: (p0) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer:
          FutureBuilder(future: bookmarksFuture, builder: futureListBuilder),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.book),
          ),
        ),
      ),
      body:
          FutureBuilder(future: bookmarksFuture, builder: futureContentBuilder),
    );
  }
}
