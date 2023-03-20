import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibGrid extends StatefulWidget {
  const LibGrid({super.key});

  @override
  State<LibGrid> createState() => _LibGridState();
}

class _LibGridState extends State<LibGrid> {
  Future<List<BookCover>> loadTitles(String? path) async {
    if (path == '') return [];

    return [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // libBloc.dispose();
    super.dispose();
  }

  // List<Book> books = await getBooks('~/bigboy/Manga/Holyland');
  @override
  Widget build(BuildContext context) {
    // return Text("OFF");
    return Container(
        // color: Colors.orange,
        padding: const EdgeInsets.all(30),
        child: BlocBuilder<LibBloc, String>(
          builder: (context, state) {
            print(">>");
            print(state);
            print("__");
            return FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                        padding: const EdgeInsets.all(20),
                        primary: false,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: snapshot.data!
                            .map((e) => Image.file(File(e.path)))
                            .toList());
                  } else {
                    return const Text('loading...');
                  }
                },
                future: loadTitles(state));
          },
        ));
  }
}
//  StreamBuilder(
//               builder: (context, snapshot) {
//                 return Text(snapshot.data ?? "Some data");
//               },
//               stream: libBloc.libStream,
//             )

