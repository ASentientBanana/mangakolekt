import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/store/library.dart';

class SearchButton extends StatefulWidget {
  SearchButton({Key? key}) : super(key: key);

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  final textEditingController = TextEditingController();
  bool showSearchBar = false;

  final libraryStore = locator<LibraryStore>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    if (!showSearchBar) {
      return Container(
        color: colorScheme.background,
        child: IconButton(
          onPressed: () {
            setState(() {
              showSearchBar = true;
            });
          },
          icon: const Icon(Icons.search_sharp),
        ),
      );
    }

    const width = 0.6;

    return SizedBox(
      width: size.width * width,
      height: 35,
      child: TextField(
        style: const TextStyle(fontSize: 13),
        onTapOutside: (e) {
          setState(() {
            showSearchBar = false;
          });
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          hintText: "Search books",
          hintStyle: TextStyle(color: colorScheme.onPrimary),
          fillColor: colorScheme.background,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(width: 1, color: colorScheme.onPrimary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(width: 1, color: colorScheme.onPrimary),
          ),
        ),
        onChanged: (s) => libraryStore.search(s),
        controller: textEditingController,
      ),
    );
  }
}
