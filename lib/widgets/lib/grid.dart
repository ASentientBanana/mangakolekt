import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/widgets/dragAndDropManga.dart';
import 'package:mangakolekt/widgets/lib/grid_item.dart';

class LibGrid extends StatefulWidget {
  const LibGrid({super.key});

  @override
  State<LibGrid> createState() => _LibGridState();
}

class _LibGridState extends State<LibGrid> {
  Future<List<BookCover>> _title = Future(() => []);

  int calculateSize(double w) {
    if (w < 1000) {
      return 1;
    } else if (w > 1700) {
      return 4;
    } else if (w > 1000 && w < 1400) {
      return 2;
    } else if (w > 1400 && w < 1700) {
      return 3;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      // color: Colors.orange,
      padding: const EdgeInsets.all(30),
      child: BlocListener<LibraryBloc, LibraryState>(
        listenWhen: (prev, current) {
          if (prev is LibraryLoaded && current is LibraryLoaded) {
            return prev.libStore.cover != current.libStore.cover;
          }
          return false;
        },
        listener: (context, state) {
          if (state is LibraryLoaded) {
            setState(() {
              _title = DatabaseMangaHelpers.getCoversFromMangaMap(
                  state.libStore.cover.id);
            });
          }
        },
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final l = snapshot.data!.map((e) {
                return GridItem(item: e);
              }).toList();
              if (l.isEmpty) {
                return DragAndDropSurface();
              }
              return Scrollbar(
                // controller: _scrollController,
                radius: Radius.zero,
                child: GridView.count(

                    // padding: const EdgeInsets.all(20),
                    primary: true,
                    crossAxisCount: calculateSize(width),
                    mainAxisSpacing: 100,
                    crossAxisSpacing: 10,
                    children: l),
              );
            } else {
              return DragAndDropSurface();
            }
          },
          future: _title,
        ),
      ),
    );
  }
}
