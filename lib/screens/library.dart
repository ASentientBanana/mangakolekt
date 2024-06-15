import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/store/library.dart';
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
  final textEditingController = TextEditingController();
  final libraryStore = locator<LibraryStore>();

  void selectManga(BookCover cover) {
    setState(() {
      selectedCover = cover;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        top: (Platform.isAndroid || Platform.isIOS),
        child: MangaMenuBar(
          child: Container(
            padding: const EdgeInsets.all(4),
            color: colorScheme.background,
            child: Row(
              children: [
                Observer(builder: (_) {
                  if (libraryStore.library.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return LibList(
                    libraryList: libraryStore.library,
                  );
                }),
                const Expanded(child: LibGrid())
              ],
            ),
          ),
        ),
      ),
    );
    // return
  }
}
