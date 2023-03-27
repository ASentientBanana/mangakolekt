import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/models/store.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib_grid_item.dart';

class LibGrid extends StatefulWidget {
  const LibGrid({super.key});

  @override
  State<LibGrid> createState() => _LibGridState();
}

class _LibGridState extends State<LibGrid> {
  Future<List<BookCover>> loadTitles(BookCover? libBook) async {
    if (libBook?.path == '' || libBook == null) return [];
    final lib = await readFromLib(libBook);
    return lib;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.orange,
        padding: const EdgeInsets.all(30),
        child: BlocBuilder<LibBloc, MangaStore>(
          builder: (context, state) {
            return FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(

                        // padding: const EdgeInsets.all(20),
                        primary: false,
                        crossAxisCount: 2,
                        mainAxisSpacing: 100,
                        crossAxisSpacing: 10,
                        children: snapshot.data!
                            .map((e) => GridItem(item: e))
                            .toList());
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
                future: loadTitles(state.cover));
          },
        ));
  }
}
