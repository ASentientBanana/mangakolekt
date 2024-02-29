import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        top: (Platform.isAndroid || Platform.isIOS),
        child: MangaMenuBar(
          child: Container(
            padding: const EdgeInsets.all(4),
            color: Theme.of(context).colorScheme.background,
            child: const Row(
              children: [LibList(), Expanded(child: LibGrid())],
            ),
          ),
        ),
      ),
    );
    // return
  }
}
