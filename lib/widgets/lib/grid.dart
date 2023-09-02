import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib/grid_item.dart';

class LibGrid extends StatelessWidget {
  const LibGrid({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        // color: Colors.orange,
        padding: const EdgeInsets.all(30),
        child:
            BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
          if (state is LibraryLoaded) {
            return FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final l = snapshot.data!.map((e) {
                    return GridItem(item: e);
                  }).toList();
                  if (l.isEmpty) {
                    return Container();
                  }
                  return GridView.count(
                      // padding: const EdgeInsets.all(20),
                      primary: false,
                      crossAxisCount: width > 1000 ? 2 : 1,
                      mainAxisSpacing: 100,
                      crossAxisSpacing: 10,
                      children: l);
                } else {
                  return const SizedBox.shrink();
                }
              },
              future: loadTitles(state.libStore.cover),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }));
  }
}
