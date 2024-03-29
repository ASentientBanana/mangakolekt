import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/widgets/library/addToLibraryModal.dart';
import 'package:mangakolekt/widgets/library/grid.dart';
import 'package:mangakolekt/widgets/library/list.dart';
import 'package:mangakolekt/widgets/menuBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BookCover? selectedCover;

  void selectManga(BookCover cover) {
    setState(() {
      selectedCover = cover;
    });
  }

  Widget modalBuilder(BuildContext context, LibraryState state) {
    if (state is! LibraryLoaded) {
      return const SizedBox.shrink();
    }

    if (state.modalPath.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Visibility(
        visible: true,
        child: Center(
          child: AddToLibraryModal(
            selectedDir: state.modalPath,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: MangaMenuBar(
          child: Container(
        padding: const EdgeInsets.all(4),
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            const Row(
              children: [LibList(), Expanded(child: LibGrid())],
            ),
            BlocBuilder<LibraryBloc, LibraryState>(
              builder: modalBuilder,
            )
          ],
        ),
      )),
    );
    // return
    //
    // MangaMenuBar(
    //       child: ),
  }
}
