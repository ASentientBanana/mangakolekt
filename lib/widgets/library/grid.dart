import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/util.dart';
import 'package:mangakolekt/widgets/dragAndDropManga.dart';
import 'package:mangakolekt/widgets/library/gridItem.dart';

class LibGrid extends StatefulWidget {
  const LibGrid({super.key});

  @override
  State<LibGrid> createState() => _LibGridState();
}

class _LibGridState extends State<LibGrid> {
  Future<List<BookCover>> _title = Future(() => []);
  String search = '';
  int? id;

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

  List<Widget> filterList(String _search, List<GridItem> list) {
    if (search.isEmpty) {
      return list;
    }
    return list
        .where((element) =>
            element.item.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  bool listenWhenGuard(LibraryState previous, LibraryState current) {
    print("Setting ");

    if (previous is! LibraryLoaded || current is! LibraryLoaded) {
      return false;
    }
    if (previous.search != current.search) {
      return true;
    }
    if (previous.libStore.libIndex != current.libStore.libIndex) {
      print('Index changed');
      return true;
    }
    return false;
  }

  void listenerCb(BuildContext context, LibraryState state) {
    if ((state is! LibraryLoaded)) {
      return;
    }
    setState(() {
      if (search != state.search) {
        search = state.search;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      // color: Colors.orange,
      padding: const EdgeInsets.all(30),
      child: BlocListener<LibraryBloc, LibraryState>(
        listenWhen: listenWhenGuard,
        listener: listenerCb,
        child: Builder(builder: (context) {
          final state = context.read<LibraryBloc>().state;
          if (state is! LibraryLoaded) {
            return DragAndDropSurface();
          }

          if (state.libStore.libIndex == null) {
            return DragAndDropSurface();
          }

          final covers = state.libStore.libElements[state.libStore.libIndex!];
          final gridItems = sortCoversNumeric(covers.books)
              .map((e) => GridItem(item: e))
              .toList();
          return Scrollbar(
              radius: Radius.zero,
              child: GridView.count(
                primary: true,
                crossAxisCount: calculateSize(width),
                mainAxisSpacing: 100,
                crossAxisSpacing: 10,
                children: filterList(search, gridItems),
              ));
        }),
      ),
    );
  }
}
