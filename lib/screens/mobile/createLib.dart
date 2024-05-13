import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/util/files.dart';

class CreateLibraryMobile extends StatelessWidget {
  final String path;

  CreateLibraryMobile({Key? key, required this.path}) : super(key: key);

  final textController = TextEditingController();
  final libraryStore = locator<LibraryStore>();
  final _navigationService = locator<NavigationService>();
  final double buttonHorizontalMargins = 20;

  void handleConfirm() async {
    final out = await getGlobalCoversDir();
    final res = await ArchiveController.unpackCovers(path, out);
    if (res == null) {
      return;
    }
    await DatabaseMangaHelpers.addLibrary(
        libraryPath: path, name: textController.text, books: res);
    final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();
    if (mangaList.isNotEmpty) {
      libraryStore.setLibrary(mangaList);
    }

    _navigationService.pushAndPop('/library', null);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter a name for the lib located at:'),
          Text(path),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: TextFormField(
              controller: textController,
              showCursor: true,
              cursorColor: colorScheme.tertiary,
              decoration: InputDecoration(
                hintText: "Enter a label for the lib",
                hintStyle: const TextStyle(color: Colors.white60),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(width: 1, color: colorScheme.tertiary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(width: 1, color: colorScheme.secondary),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: buttonHorizontalMargins),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: colorScheme.tertiary,
                  shape: const BeveledRectangleBorder(),
                  side: BorderSide(color: colorScheme.secondary)),
              onPressed: () => handleConfirm(),
              child: const Text(
                "Add",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: buttonHorizontalMargins),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // backgroundColor: colorScheme.tertiary,
                  // minimumSize: Size.fromHeight(double.infinity),
                  shape: const BeveledRectangleBorder(),
                  side: BorderSide(color: colorScheme.secondary)),
              onPressed: () {},
              child: const Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
