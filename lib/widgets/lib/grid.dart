import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/store.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib/grid_item.dart';

class LibGrid extends StatelessWidget {
  const LibGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.orange,
        padding: const EdgeInsets.all(30),
        child: BlocBuilder<LibBloc, LibStore>(builder: (context, snapshot) {
          return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    // padding: const EdgeInsets.all(20),
                    primary: false,
                    crossAxisCount: 2,
                    mainAxisSpacing: 100,
                    crossAxisSpacing: 10,
                    children:
                        snapshot.data!.map((e) => GridItem(item: e)).toList());
              } else {
                return const CircularProgressIndicator();
              }
            },
            future: loadTitles(snapshot.cover),
          );
        }));
  }
}
