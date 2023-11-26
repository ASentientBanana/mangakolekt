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
              return GridView.count(
                  // padding: const EdgeInsets.all(20),
                  primary: false,
                  crossAxisCount: width > 1000 ? 2 : 1,
                  mainAxisSpacing: 100,
                  crossAxisSpacing: 10,
                  children: l);
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
