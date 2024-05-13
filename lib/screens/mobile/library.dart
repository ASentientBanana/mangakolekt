import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/widgets/homeLogo.dart';
import 'package:mangakolekt/widgets/library/listItem.dart';
import 'package:mangakolekt/widgets/mobile/libraryActionButton.dart';
import 'package:mangakolekt/widgets/mobile/libraryDrawer.dart';

class MyHomePageMobile extends StatefulWidget {
  const MyHomePageMobile({super.key});
  @override
  State<MyHomePageMobile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageMobile> {
  BookCover? selectedCover;
  final textEditingController = TextEditingController();

  final libraryStore = locator<LibraryStore>();

  bool disableAdd = false;

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
      drawer: SafeArea(child: LibraryDrawer()),
      appBar: AppBar(actions: [
        SizedBox(
          width: 300,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              children: [
                Container(
                  height: 32,
                  padding: const EdgeInsets.only(right: 15),
                  child: Material(
                      child: TextField(
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      hintText: "Search books",
                      hintStyle: TextStyle(color: colorScheme.onPrimary),
                      fillColor: colorScheme.background,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(width: 1, color: colorScheme.onPrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(width: 1, color: colorScheme.onPrimary),
                      ),
                    ),
                    onChanged: (s) {
                      libraryStore.search(s);
                    },
                    controller: textEditingController,
                  )),
                ),
                Positioned(
                  top: 4,
                  right: 25,
                  child: Icon(
                    Icons.search_sharp,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            )
          ]),
        ),
      ]),
      body: SafeArea(
        // color: Colors.red,
        child: Observer(builder: (_) {
          if (libraryStore.library.isEmpty) {
            return HomeLogo();
          }
          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: LibListItem(
                        item: libraryStore.library[index], index: index),
                  ),
              separatorBuilder: (_, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: libraryStore.library.length);
        }),
      ),
      // child: LibList(),

      floatingActionButton: CreateLibraryActionButton(),
    );
    // return
  }
}
