import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/store.dart';
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
          return FutureBuilder(
            builder: (context, snapshot) {
              int index = 0;
              final list = snapshot.data?.map((e) {
                return LibListItem(item: e, index: index);
              }).toList();
              return SizedBox(
                // width: 200,
                child: Column(
                  children: list ??
                      [const Flexible(child: Text("No libraries added"))],
                ),
              );
            },
            future: readAppDB(),
          );
        },
      ),
    );
  }
}
