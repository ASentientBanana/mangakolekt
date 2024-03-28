import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/widgets/homeLogo.dart';
import 'package:mangakolekt/widgets/library/grid.dart';
import 'package:mangakolekt/widgets/library/list.dart';
import 'package:mangakolekt/widgets/mobile/libraryDrawer.dart';

class MyHomePageMobile extends StatefulWidget {
  const MyHomePageMobile({super.key});
  @override
  State<MyHomePageMobile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageMobile> {
  BookCover? selectedCover;
  final textEditingController = TextEditingController();

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
                      context.read<LibraryBloc>().add(SearchLib(searchTerm: s));
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
        child: HomeLogo(),
        // child: LibList(),
      ),
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 3, color: Color.fromARGB(255, 238, 245, 238)),
              borderRadius: BorderRadius.circular(100)),
          backgroundColor: colorScheme.background,
          onPressed: () {},
          child: const Icon(size: 42, Icons.add)),
    );
    // return
  }
}
