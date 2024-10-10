import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/widgets/homeLogo.dart';
import 'package:mangakolekt/widgets/library/listItem.dart';
import 'package:mangakolekt/widgets/mobile/libraryActionButton.dart';
import 'package:mangakolekt/widgets/mobile/libraryDrawer.dart';
import 'package:mangakolekt/widgets/mobile/searchButton.dart';

class MyHomePageMobile extends StatefulWidget {
  const MyHomePageMobile({super.key});
  @override
  State<MyHomePageMobile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageMobile> {
  BookCover? selectedCover;
  bool showSearchBox = false;

  final libraryStore = locator<LibraryStore>();

  bool disableAdd = false;

  void selectManga(BookCover cover) {
    setState(() {
      selectedCover = cover;
    });
  }

  Widget listBuilder(BuildContext _) {
    if (libraryStore.library.isEmpty) {
      return HomeLogo();
    }
    final lib = libraryStore.library
        .where((element) => element.name.contains(libraryStore.searchTerm))
        .toList();
    
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(left: 30),
                child: LibListItem(item: lib[index], index: index),
              ),
          separatorBuilder: (_, index) => const SizedBox(
                height: 10,
              ),
          itemCount: lib.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: SafeArea(child: LibraryDrawer()),
      appBar: AppBar(
          shape:
              const Border(bottom: BorderSide(color: Colors.white, width: 1)),
          actions: [
            SearchButton(),
          ]),
      body: SafeArea(
        // color: Colors.red,
        child: Observer(
          builder: listBuilder,
        ),
      ),
      // child: LibList(),

      floatingActionButton: CreateLibraryActionButton(),
    );
    // return
  }
}
