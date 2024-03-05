import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
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
      // appBar: AppBar(
      // actions: [
      //   SizedBox(
      //     width: 300,
      //     child:
      //         Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       Stack(
      //         children: [
      //           Container(
      //             height: 32,
      //             padding: EdgeInsets.only(right: 15),
      //             child: Material(
      //                 child: TextField(
      //               style: const TextStyle(fontSize: 13),
      //               decoration: InputDecoration(
      //                 contentPadding: EdgeInsets.symmetric(horizontal: 5),
      //                 hintText: "Search books",
      //                 hintStyle: TextStyle(color: colorScheme.onPrimary),
      //                 fillColor: colorScheme.background,
      //                 filled: true,
      //                 focusedBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.zero,
      //                   borderSide: BorderSide(
      //                       width: 1, color: colorScheme.onPrimary),
      //                 ),
      //                 enabledBorder: OutlineInputBorder(
      //                   borderRadius: BorderRadius.zero,
      //                   borderSide: BorderSide(
      //                       width: 1, color: colorScheme.onPrimary),
      //                 ),
      //               ),
      //               onChanged: (s) {
      //                 context
      //                     .read<LibraryBloc>()
      //                     .add(SearchLib(searchTerm: s));
      //               },
      //               controller: textEditingController,
      //             )),
      //           ),
      //           Positioned(
      //             top: 4,
      //             right: 25,
      //             child: Icon(
      //               Icons.search_sharp,
      //               color: colorScheme.onPrimary,
      //             ),
      //           ),
      //         ],
      //       )
      //     ]),
      //   )
      // ],
      // ),
      // drawer: Drawer(
      //   backgroundColor: colorScheme.background,
      //   child: LibList(),
      // ),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        top: (Platform.isAndroid || Platform.isIOS),
        child: MangaMenuBar(
          child: Container(
            padding: const EdgeInsets.all(4),
            color: colorScheme.background,
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
