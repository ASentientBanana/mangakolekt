import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib/list_item.dart';

class LibList extends StatelessWidget {
  const LibList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      padding: const EdgeInsets.all(30),
      child: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          final _db = readAppDB();
          return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Widget> list = [];
                final len = snapshot.data!.length;
                for (var i = 0; i < len; i++) {
                  list.add(LibListItem(item: snapshot.data![i], index: i));
                }
                return SizedBox(
                  width: 200,
                  child: Column(children: list),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
            future: _db,
          );
        },
      ),
    );
  }
}
