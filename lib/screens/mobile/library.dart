import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/widgets/library/list.dart';

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
      // appBar:
      // ],
      // ),
      // drawer: Drawer(
      //   backgroundColor: colorScheme.background,
      //   child: LibList(),
      // ),
      backgroundColor: colorScheme.background,
      appBar: AppBar(actions: [
        SizedBox(
          width: 300,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              children: [
                Container(
                  height: 32,
                  padding: EdgeInsets.only(right: 15),
                  child: Material(
                      child: TextField(
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
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
        child: Drawer(
          backgroundColor: colorScheme.background,
          child: const LibList(),
        ),
      ),
    );
    // return
  }
}
