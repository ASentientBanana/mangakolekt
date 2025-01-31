import 'package:flutter/material.dart';
import 'package:mangakolekt/models/database/bookmark.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkElement.dart';
import 'package:mangakolekt/widgets/modals/bookmarks/bookmarkMangaButton.dart';

class BookmarksMobile extends StatefulWidget {
  const BookmarksMobile({super.key});

  @override
  _BookmarksMobileState createState() => _BookmarksMobileState();
}

class _BookmarksMobileState extends State<BookmarksMobile> {
  Future<Bookmarks?> bookmarksFuture = Future(() => null);
  int bookmarkIndex = 0;
  bool isLoadingState = false;

  void getBookmarks() {
    setState(() {
      bookmarksFuture = DatabaseMangaHelpers.getAllBookmarks();
    });
  }

  @override
  void initState() {
    getBookmarks();
    super.initState();
  }

  Future<void> action(Future Function() cb) async {
    setState(() {
      isLoadingState = true;
    });
    await cb();
    setState(() {
      isLoadingState = false;
    });
  }

  Widget bookmarkElementBuilder(BookmarksData item, int index) {
    return BookmarkElement(
        refetch: getBookmarks,
        bookmarkItem: item.bookmarks[index],
        bookData: item,
      deleteBookmarkCb:(int id, int page) =>
            DatabaseMangaHelpers.removeBookmark(id,page));
  }

  Widget futureContentBuilder(
      BuildContext context, AsyncSnapshot<Bookmarks?> snapshot) {
    if (!snapshot.hasData) {
      return const Center(
        child: Text("No bookmarks loaded"),
      );
    }

    if (snapshot.data!.data.isEmpty) {
      return const Center(
        child: Text("No bookmarks added"),
      );
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
      backgroundColor: colorScheme.surface,
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
